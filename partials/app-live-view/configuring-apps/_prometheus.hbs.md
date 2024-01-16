  1. Create a file named `prometheus-scrape-config.yaml` with the following content:

      ```yaml
      # Example scrape config for pods
      #
      # The relabeling allows the actual pod scrape endpoint to be configured through the
      # following annotations:
      #
      # * `prometheus.io/scrape`: Only scrape pods that have a value of `true`.
      # * `prometheus.io/scheme`: If the metrics endpoint is secured then you must
      # set this to `https` and most likely set the `tls_config` of the scrape config.
      # * `prometheus.io/path`: If the metrics path is not `/metrics` override this.
      # * `prometheus.io/port`: Scrape the pod on the indicated port instead of the default of `9102`.
      - job_name: 'kubernetes-pods'
        honor_labels: true

        kubernetes_sd_configs:
          - role: pod

        relabel_configs:
          - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_scrape]
            action: keep
            regex: true
          - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_scheme]
            action: replace
            regex: (https?)
            target_label: __scheme__
          - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_path]
            action: replace
            target_label: __metrics_path__
            regex: (.+)
          - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_port, __meta_kubernetes_pod_ip]
            action: replace
            regex: (\d+);(([A-Fa-f0-9]{1,4}::?){1,7}[A-Fa-f0-9]{1,4})
            replacement: '[$2]:$1'
            target_label: __address__
          - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_port, __meta_kubernetes_pod_ip]
            action: replace
            regex: (\d+);((([0-9]+?)(\.|$)){4})
            replacement: $2:$1
            target_label: __address__
          - action: labelmap
            regex: __meta_kubernetes_pod_annotation_prometheus_io_param_(.+)
            replacement: __param_$1
          - action: labelmap
            regex: __meta_kubernetes_pod_label_(.+)
          - source_labels: [__meta_kubernetes_namespace]
            action: replace
            target_label: namespace
          - source_labels: [__meta_kubernetes_pod_name]
            action: replace
            target_label: pod
          - source_labels: [__meta_kubernetes_pod_phase]
            regex: Pending|Succeeded|Failed|Completed
            action: drop
          - source_labels: [__meta_kubernetes_pod_node_name]
            action: replace
            target_label: node
      ```

  1. Generate a secret using the file you just created by running:

      ```console
      kubectl create secret generic additional-scrape-configs --from-file=prometheus-scrape-config.yaml
      ```