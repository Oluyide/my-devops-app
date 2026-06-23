# Deploy Setup — change a file → push → auto-deploy to EC2

This repo deploys **my-devops-app** to your AWS EC2 instance automatically.
Implemented strategy (the simplest of the options in the PDFs):

- **Connection:** SSH key (`appleboy/ssh-action`) — see `docs/deploy-method-options.pdf`
- **Build:** `git pull` + `docker build` **on the EC2 box** — see `docs/build-strategy-options.pdf`

## How it flows

```
edit a file ──git push──▶ GitHub Actions ──▶ lint ▶ test ▶ build+Trivy ▶ deploy(SSH)
                                                                            └─ on EC2: fetch + docker build + run + health check
```

The `deploy` job runs only on pushes to `main` (or a manual **Run workflow**), and only
after lint, test, and the Trivy scan pass.

## One-time setup

### 1. Create an EC2 key pair
```bash
aws ec2 create-key-pair --key-name my-devops-app-key \
  --query 'KeyMaterial' --output text > my-devops-app-key.pem
chmod 400 my-devops-app-key.pem
```

### 2. Attach the key + recreate the instance (Terraform)
```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars   # set key_name + allowed_ssh_cidr (your IP/32)
terraform apply                                # replaces the EC2 (user_data_replace_on_change)
terraform output public_ip                     # note this for the secret below
```

### 3. Add GitHub repository secrets
Repo → **Settings → Secrets and variables → Actions → New repository secret**:

| Secret | Value |
| --- | --- |
| `EC2_HOST` | the `public_ip` from `terraform output` |
| `EC2_USER` | `ec2-user` |
| `EC2_SSH_KEY` | full contents of `my-devops-app-key.pem` (BEGIN…END) |

### 4. Deploy
- **Automatic:** edit any file → `git commit` → `git push origin main`.
- **Manual:** GitHub → **Actions → CI → Run workflow**.

Watch it in the **Actions** tab. When `deploy` is green, the new version is live at
`http://<EC2_HOST>:3000` (and `/health`).

## Notes
- The deploy uses `git reset --hard origin/main` because the box was cloned shallow — it
  always matches `main` exactly, no merge conflicts.
- `docker image prune -f` runs each deploy so old layers don't fill the t3.micro disk.
- A failed health check fails the job, so a broken deploy is visible immediately.
- To graduate to a more secure / production-like setup (AWS SSM, or pushing images to a
  registry for instant rollback), follow the steps in the two PDFs.
```
