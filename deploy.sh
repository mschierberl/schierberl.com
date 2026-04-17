#!/usr/bin/env bash
set -euo pipefail

BUCKET="${S3_BUCKET:-schierberl.com}"
DISTRIBUTION_ID="${CLOUDFRONT_DISTRIBUTION_ID:-}"

echo "→ Syncing HTML..."
aws s3 cp index.html "s3://${BUCKET}/index.html" \
  --cache-control "public, max-age=0, must-revalidate" \
  --content-type "text/html; charset=utf-8"

echo "→ Syncing static files..."
aws s3 cp social.png "s3://${BUCKET}/social.png" \
  --cache-control "public, max-age=604800" \
  --content-type "image/png"
aws s3 cp favicon.svg "s3://${BUCKET}/favicon.svg" \
  --cache-control "public, max-age=604800" \
  --content-type "image/svg+xml"
aws s3 cp favicon.ico "s3://${BUCKET}/favicon.ico" \
  --cache-control "public, max-age=604800" \
  --content-type "image/x-icon"
aws s3 cp robots.txt "s3://${BUCKET}/robots.txt" \
  --cache-control "public, max-age=86400" \
  --content-type "text/plain"
aws s3 cp sitemap.xml "s3://${BUCKET}/sitemap.xml" \
  --cache-control "public, max-age=86400" \
  --content-type "application/xml"

if [[ -n "${DISTRIBUTION_ID}" ]]; then
  echo "→ Invalidating CloudFront..."
  aws cloudfront create-invalidation \
    --distribution-id "${DISTRIBUTION_ID}" \
    --paths "/*"
fi

echo "✓ Done — https://${BUCKET}"
