#!/usr/bin/env sh

suffix="$(hexdump -n 3 -e '1/2 "%04x"' /dev/urandom)"

kubectl apply -f - << EOT
apiVersion: batch/v1
kind: Job
metadata:
  namespace: ${NAMESPACE}
  name: obelix-sync-${suffix}
spec:
  template:
    spec:
      nodeName: ${NODE}
      restartPolicy: OnFailure
      hostNetwork: true
      dnsPolicy: ClusterFirstWithHostNet
      serviceAccountName: obelix
      containers:
        - name: obelix
          image: ${OBELIX_IMAGE}
          command: ["python", "-m", "obelix", "sync", "--prefix", "deploy/hosted/"]
          volumeMounts:
            - mountPath: /products
              name: products
            - mountPath: /deploy
              name: deploy
      volumes:
        - hostPath:
            path: /products
            type: Directory
          name: products
        - hostPath:
            path: /deploy
            type: Directory
          name: deploy
EOT
