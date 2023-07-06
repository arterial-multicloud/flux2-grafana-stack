# opstesting

## testpod-wi

Ensure you store the secret

```bash
az keyvault secret set --vault-name $KVNAME --name testpod-wi-secrets-sa --value mysecretvalue
```

After deployment check that you can see the secret mounted in the filesystem

```bash
$ k exec -it testpod-wi-6d4d57dc6d-mxthn -n opstesting -- sh

/ # ls /mnt/secrets-store/testpod-wi-secrets-sa
/mnt/secrets-store/testpod-wi-secrets-sa

/ # cat /mnt/secrets-store/testpod-wi-secrets-sa
mysecretvalue/
```
