# Software Factory

Use git guardian to avoid leaking secrets
```bash
ggshield install --mode local -t pre-push
```

Before pushing, to check whether the 
```bash
sudo act -W ./.github/workflows/feature-branch.yml --secret-file ./my.secrets
```
