# Deployment

## Overview

Converge is distributed as a macOS app. The README references manual GitHub Releases downloads, a curl installer, and Sparkle automatic updates.

## Release Inputs

- A signed macOS app archive.
- A release artifact published through the configured release channel.
- Sparkle appcast/update metadata when automatic updates are enabled.

## Notes

- Confirm the signing identity, notarization flow, and Sparkle feed before creating releases.
- Keep the public download site and README install command aligned with the actual release artifact.
