# Terraform files for dabit server

This is the terraform files used to deploy [dabit-server](https://github.com/dabit-app/dabit-server) on the self-hosted k8s.
The API is available at [api.dabit.alaanor.dev](https://api.dabit.alaanor.dev)

## Deployment

``` bash
terraform -chdir=./src/ apply -var-file=../deployments/[insert environment].tfvars
```

## Variables

### Connect to k8s

There's 2 way to connect to kubernetes.
 1. Using a kubeconfig file
 2. Supplying credentials

In local for development purpose, you would typically use a kubemap. Set the config context through an environment variable `TF_VAR_k8s_config_context` and all should works just fine.

| name | default |
|------|---------|
| [k8s_config_path](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs#config_path) | ~/.kube/config |
| [k8s_config_context](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs#config_context) | null |
|||
| [k8s_host](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs#host) | null |
| [k8s_client_certificate](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs#client_certificate) | null |
| [k8s_client_key](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs#client_key) | null |
| [k8s_cluster_ca_certificate](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs#cluster_ca_certificate) | null |

### Deployments options

| name | description | default |
|------|-------------|---------|
| host | hostname for the ingress | localhost |
| namespace | name of kubernetes namespace for all resources deployed | default |
| habit_api_replicas | number of replicas for Habit.API | 1 |
| identity_api_replicas | number of replicas for Identity.API | 1 |

## Resources

 - Deployments
   - Habit.API
   - Habit.Worker
   - Identity.API
   - Traefik
 - StatefulSets
   - Event Store
   - Mongo (habit)
   - Mongo (user)
 - ConfigMap
 - Secrets
 - Ingress (traefik)

### Rational

The reason there's 2 mongodb is because one is built from the event store (Habit.Worker's job, it's a read-only db).
Thus mongo-db-habit isn't entirely a true stateful db since its state can be rebuilt from the event store.
Which means that theorically we could destroy the db entirely and rebuild (could be how migrations are done in the future), for that reason I prefer separating them.


