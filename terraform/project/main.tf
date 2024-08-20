module "adot" {
  source = "makandra/adot/eks"
  version = "1.0.4"

  cert-manager = false
  cluster_name = local.cluster_name
  adot_version = "v0.92.1-eksbuild.1"
}

resource "helm_release" "adot-collector" {
  name = "adot-collector"
  repository       = "https://makandra.github.io/aws-otel-helm-charts/"
  chart            = "adot-exporter-for-eks-on-ec2"
  namespace        = "adot"
  version          = "0.11.1"
  create_namespace = false
  atomic           = true

  values = [
    templatefile("./templates/adot-values.tpl", {
      region       = local.region
      cluster_name = local.cluster_name
      # the namespace regex is used to exclude metrics of those namespaces from being sent to cloudwatch
      drop_namespace_regex = "(amazon-cloudwatch|kube-system|adot|exampleapp.*|opentelemetry-operator-system)"
      log_group_name       = local.adot_log_group_name
    })
  ]
}

resource "aws_cloudwatch_log_group" "adot" {
  name              = local.adot_log_group_name
  retention_in_days = var.log_rentention_days

}


resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = "v1.15.1"

  namespace  = "cert-manager"
  create_namespace = true

  set {
    name  = "installCRDs"
    value = "true"
  }

  set {
    name  = "global.leaderElection.namespace"
    value = "cert-manager"
  }

  set {
    name  = "prometheus.enabled"
    value = "true"
  }

  set {
    name  = "serviceAccount.create"
    value = "true"
  }
}