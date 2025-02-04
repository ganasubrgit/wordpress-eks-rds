resource "helm_release" "wordpress" {
  name       = "wordpress"
  chart      = "bitnami/wordpress"
  repository = "https://charts.bitnami.com/bitnami"
  version    = "15.2.5"

  set {
    name  = "externalDatabase.host"
    value = aws_db_instance.rds_instance.endpoint
  }

  set {
    name  = "externalDatabase.user"
    value = var.rds_username
  }

  set {
    name  = "externalDatabase.password"
    value = var.rds_password
  }

  set {
    name  = "externalDatabase.database"
    value = "wordpressdb"
  }

  set {
    name  = "externalDatabase.port"
    value = "3306"
  }

  set {
    name  = "service.type"
    value = "LoadBalancer"
  }

  set {
    name  = "wordpressUsername"
    value = "admin"
  }

  set {
    name  = "wordpressPassword"
    value = "admin123!"
  }
}
