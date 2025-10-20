# Release Process

This repository uses GitHub Actions to automatically update the Homebrew tap when a new release is created.

## One-Time Setup

### Create a Personal Access Token

1. Go to https://github.com/settings/tokens/new
2. Name it "Homebrew Tap Updater" or similar
3. Select scopes:
   - `public_repo` (or `repo` if using private repos)
4. Click "Generate token"
5. Copy the token (you won't see it again!)

### Add Token to Repository Secrets

1. Go to https://github.com/BlakeASmith/scrman/settings/secrets/actions
2. Click "New repository secret"
3. Name: `COMMITTER_TOKEN`
4. Value: paste the token you copied
5. Click "Add secret"

## Making a Release

### Simple Method (Recommended)

```bash
# Make your changes, commit them
git add .
git commit -m "Your changes"
git push origin main

# Create and push a tag
./scripts/release.sh 0.2.0
```

### Manual Method

```bash
# Update version
echo "0.2.0" > VERSION

# Commit and push
git add .
git commit -m "Release v0.2.0"
git push origin main

# Create and push tag
git tag -a v0.2.0 -m "Release version 0.2.0"
git push origin v0.2.0
```

### What Happens Next

1. The tag push triggers the GitHub Action
2. The action downloads the release tarball
3. It calculates the SHA256 hash
4. It updates the formula in `homebrew-tap` repository
5. It commits and pushes the changes

That's it! Your users can now update with:
```bash
brew update
brew upgrade scrman
```

## Troubleshooting

**Action fails with "403 Forbidden"**
- Check that `COMMITTER_TOKEN` is set correctly
- Verify the token has `public_repo` permissions
- Make sure the token hasn't expired

**SHA256 mismatch**
- The action will automatically calculate the correct SHA256
- If it still fails, check that the tag was pushed correctly

**Formula not updating**
- Check the Actions tab for error messages
- Verify the tap repository URL is correct

