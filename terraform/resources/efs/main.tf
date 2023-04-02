# Define Jenkins EFS

resource "aws_efs_file_system" "jenkins" {
  creation_token = "jenkins-efs"

  tags = {
    Name = "Jenkins EFS"
  }
}

resource "aws_efs_mount_target" "jenkins" {
  for_each       = var.jenkins_vpc_private_subnet_ids
  file_system_id = aws_efs_file_system.jenkins.id
  subnet_id      = each.value
  security_groups = [
    var.jenkins_efs_sg_id
  ]
}

resource "aws_efs_access_point" "jenkins" {
  file_system_id = aws_efs_file_system.jenkins.id

  posix_user {
    uid = 1000
    gid = 1000
  }
  root_directory {
    path = "/jenkins-home"

    creation_info {
      owner_gid   = 1000
      owner_uid   = 1000
      permissions = "0755"
    }
  }

  tags = {
    Name = "Jenkins EFS Access Point"
  }
}
