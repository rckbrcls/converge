# Security

Converge is a local macOS app, but it still has security-sensitive areas: sandboxing, network access, update signing, release automation, installer behavior, and local user data.

## App Sandbox and Entitlements

`converge/Converge.entitlements` enables:

- `com.apple.security.app-sandbox`
- `com.apple.security.network.client`

The Xcode target also enables hardened runtime and app sandbox settings in `converge.xcodeproj/project.pbxproj`.

Network client access is needed for Sparkle update checks. Avoid adding broader entitlements unless a concrete app feature requires them.

## Sparkle Update Trust

Sparkle update delivery depends on matching public and private keys.

- Public key: `SUPublicEDKey` in `converge/Info.plist`.
- Private key: `SPARKLE_EDDSA_PRIVATE_KEY` GitHub Actions secret used by `.github/workflows/release.yml`.
- Appcast feed: `appcast.xml`, published through GitHub Pages.

If the private key is lost, compromised, or mismatched with `SUPublicEDKey`, updates can fail or become unsafe. Rotate keys deliberately and update the app bundle public key before relying on a new signing key.

## Secret Management

The repository ignores Sparkle key output:

- `keys/`
- `keys/eddsa_private_key.pem`
- `.sparkle-tools/`

Do not commit private Sparkle keys, exported key files, release credentials, or local signing identities.

The release workflow requires `SPARKLE_EDDSA_PRIVATE_KEY`. Store it only as a GitHub Actions secret in the canonical release repository.

## Release Signing

The current release workflow builds with code signing disabled, then re-signs the app bundle with an ad-hoc signature.

This is not the same as Apple Developer ID signing or notarization. Do not describe releases as notarized unless a verified notarization workflow is added.

## Installer Behavior

`scripts/install.sh` downloads release metadata and ZIP assets from GitHub Releases, extracts the app, installs it into `/Applications` or `$HOME/Applications`, and removes the `com.apple.quarantine` attribute when possible.

This behavior is convenient but security-sensitive:

- It trusts the configured GitHub release repository.
- It trusts the selected release ZIP asset.
- It removes quarantine metadata after installation.
- It overwrites an existing installed app bundle at the target path.

Keep the installer aligned with the canonical repository and release artifact naming.

## Local Data

Converge stores settings and session history in `UserDefaults`.

Stored data includes:

- Timer durations and auto-continue preference.
- Notification and sound preferences.
- Theme selection.
- Welcome modal state.
- Completed Pomodoro sessions with completion time and duration.

No database, server-side storage, account system, authentication, or authorization model exists in this repository.

Session history is local productivity data. Treat it as user data and avoid adding telemetry or sync without a clear consent model.

## Repository Ownership Risk

This checkout's Git remote points to `rckbrcls/converge`, while release links and update infrastructure reference `polterware/converge`.

Before release work, verify which repository owns:

- GitHub Releases.
- GitHub Pages appcast hosting.
- `SPARKLE_EDDSA_PRIVATE_KEY`.
- The public installer endpoint.
- User-facing issue and release links.

Publishing from the wrong repository can break installs, updates, or trust assumptions.

## Future Hardening

- Add a documented Developer ID signing and notarization workflow if distributing broadly outside local development.
- Add release verification steps that compare `SUPublicEDKey`, appcast URL, and release owner before publishing.
- Repair and expand tests around timer transitions and persistence before using releases as confidence gates.
- Consider documenting a privacy policy if session history sync, telemetry, or crash reporting is added.
