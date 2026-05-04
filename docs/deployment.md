# Deployment

Converge is distributed as a macOS app ZIP through GitHub Releases and updated through Sparkle appcast metadata.

## Release Ownership Check

Before publishing, verify the canonical repository owner.

In this checkout, the Git remote points to:

```text
https://github.com/rckbrcls/converge.git
```

The release workflow, appcast URLs, installer, and existing README links reference:

```text
polterware/converge
```

Do not run release work until this mismatch is resolved.

## Release Workflow

The release workflow lives at `.github/workflows/release.yml` and is manually triggered with `workflow_dispatch`.

It accepts an optional `version` input that overrides `CFBundleShortVersionString`.

The workflow:

1. Checks out the repository on a `macos-26` runner.
2. Computes `CURRENT_PROJECT_VERSION` from `GITHUB_RUN_NUMBER`.
3. Builds the `converge` Xcode scheme in Release configuration with code signing disabled.
4. Verifies that `SUPublicEDKey` and `SUFeedURL` exist in the built app's `Info.plist`.
5. Removes existing signatures and ad-hoc signs the app bundle.
6. Packages the app as `Converge-macos-universal-v{shortVersion}.zip`.
7. Resolves the minimum macOS version from the built app or Xcode build settings.
8. Downloads Sparkle tools version 2.8.1.
9. Signs the update ZIP with Sparkle EdDSA using `SPARKLE_EDDSA_PRIVATE_KEY`.
10. Updates `appcast.xml` with `scripts/update_appcast.py`.
11. Generates release notes from `CHANGELOG.md` when present, otherwise from recent Git commits.
12. Commits and pushes the updated `appcast.xml`.
13. Creates or replaces the GitHub Release for `v{shortVersion}`.
14. Publishes `public/appcast.xml` through GitHub Pages.

## Release Inputs

The workflow expects:

- Xcode project: `converge.xcodeproj`
- Xcode scheme: `converge`
- App bundle name: `converge.app`
- Display name: `Converge`
- Appcast path: `appcast.xml`
- Appcast URL: `https://polterware.github.io/converge/appcast.xml`
- Sparkle tools version: `2.8.1`
- GitHub Actions secret: `SPARKLE_EDDSA_PRIVATE_KEY`

## Appcast

`appcast.xml` is the Sparkle feed. Each release item includes:

- Release title.
- Publication date.
- Minimum macOS version.
- ZIP enclosure URL.
- Build version.
- Short version string.
- Sparkle EdDSA signature.
- ZIP length.
- macOS platform marker.

The app reads the feed through:

- `converge/Info.plist` key `SUFeedURL`.
- `converge/Services/UpdateManager.swift`, which returns the same appcast URL through `SPUUpdaterDelegate`.

Keep these values aligned.

## Installer

`scripts/install.sh` installs from GitHub Releases. It:

- Resolves either the latest release or a specific `v{version}` tag.
- Selects a `.zip` asset, preferring universal builds.
- Downloads and checks the asset size.
- Extracts the archive with `ditto`.
- Finds the first `.app` bundle.
- Installs to `/Applications` or `$HOME/Applications`.
- Removes `com.apple.quarantine` when `xattr` is available.

The public one-line install command currently points to:

```bash
curl -fsSL https://converge-focus.vercel.app/install | bash
```

No source for that hosted endpoint was identified in this repository. Keep it aligned manually with `scripts/install.sh` and the canonical release repository.

## Signing and Notarization

The current workflow performs ad-hoc code signing after building with signing disabled. It does not document or implement Apple Developer ID signing or notarization.

Do not claim notarized distribution unless a notarization workflow is added and verified.

## Pre-Release Checklist

- Confirm the canonical repository owner.
- Confirm `SUFeedURL` in `converge/Info.plist`.
- Confirm `UpdateManager` returns the same appcast URL.
- Confirm `SUPublicEDKey` matches the private key stored in `SPARKLE_EDDSA_PRIVATE_KEY`.
- Confirm the release ZIP name matches installer and appcast expectations.
- Confirm the app target deployment target is intentional.
- Confirm tests are healthy before relying on release confidence.

## Rollback

No automated rollback process exists in the repository.

Manual rollback options are limited to replacing the GitHub Release asset and appcast entry with a known-good release, then waiting for Sparkle clients to receive the corrected feed.
