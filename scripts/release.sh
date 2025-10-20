#!/bin/bash
set -e

if [ -z "$1" ]; then
  echo "Usage: ./scripts/release.sh VERSION"
  echo "Example: ./scripts/release.sh 0.2.0"
  exit 1
fi

VERSION=$1
TAG="v$VERSION"

echo "🚀 Preparing release $TAG"

# Update VERSION file
echo "$VERSION" > VERSION
echo "✅ Updated VERSION file"

# Commit changes
git add VERSION
git commit -m "Bump version to $VERSION" || echo "No changes to commit"

# Push to main
git push origin main
echo "✅ Pushed to main"

# Create and push tag
git tag -a "$TAG" -m "Release version $VERSION"
git push origin "$TAG"
echo "✅ Created and pushed tag $TAG"

echo ""
echo "🎉 Release $TAG created!"
echo ""
echo "GitHub Actions will now:"
echo "  1. Download the release tarball"
echo "  2. Calculate SHA256"
echo "  3. Update the Homebrew formula"
echo ""
echo "Check status at: https://github.com/BlakeASmith/scrman/actions"

