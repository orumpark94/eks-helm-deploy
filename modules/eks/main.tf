# EKS 클러스터용 IAM 역할
resource "aws_iam_role" "eks_cluster_role" {
  name = "${var.name}-eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })

  tags = {
    Name = "${var.name}-eks-cluster-role"
  }
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

# EKS 클러스터 생성
resource "aws_eks_cluster" "this" {
  name     = "${var.name}-eks"
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = var.private_subnet_ids
  }

  tags = {
    Name = "${var.name}-eks"
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy
  ]
}

# Node Group용 IAM 역할
resource "aws_iam_role" "node_group_role" {
  name = "${var.name}-nodegroup-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })

  tags = {
    Name = "${var.name}-nodegroup-role"
  }
}

resource "aws_iam_role_policy_attachment" "worker_node_policy" {
  role       = aws_iam_role.node_group_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "cni_policy" {
  role       = aws_iam_role.node_group_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "registry_policy" {
  role       = aws_iam_role.node_group_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role_policy_attachment" "ssm_policy" {
  role       = aws_iam_role.node_group_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# ✅ Launch Template: 비밀번호 설정 + 30000 포트 오픈
resource "aws_launch_template" "eks_node_lt" {
  name_prefix   = "${var.name}-lt-"
  instance_type = "t3.medium"

  user_data = base64encode(<<-EOF
    #!/bin/bash
    echo "==> 설정: root 비밀번호 및 포트 오픈"

    # 1. root 비밀번호 설정
    echo "root:k8s" | chpasswd

    # 2. SSH 비밀번호 로그인 허용
    sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
    sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

    # 3. SSH 재시작
    systemctl restart sshd

    # 4. 포트 30000 오픈
    iptables -I INPUT -p tcp --dport 30000 -j ACCEPT

    # 5. EKS 노드 등록
    /etc/eks/bootstrap.sh ${var.name}-eks
  EOF
  )

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.name}-node"
    }
  }
}

# Node Group 생성 (Launch Template 연결됨)
resource "aws_eks_node_group" "this" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "${var.name}-nodegroup"
  node_role_arn   = aws_iam_role.node_group_role.arn
  subnet_ids      = var.private_subnet_ids

  scaling_config {
    desired_size = 2
    max_size     = 2
    min_size     = 1
  }

  launch_template {
    id      = aws_launch_template.eks_node_lt.id
    version = "$Latest"
  }

  tags = {
    Name    = "${var.name}-nodegroup"
    AppPort = tostring(var.target_port)
  }

  depends_on = [
    aws_iam_role_policy_attachment.worker_node_policy,
    aws_iam_role_policy_attachment.cni_policy,
    aws_iam_role_policy_attachment.registry_policy
  ]
}
