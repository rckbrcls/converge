# Deployment

Converge is distributed as a **native macOS app**:

- ZIP on **GitHub Releases**
- auto-updates via **Sparkle** + `appcast.xml`
- feed hosted on **GitHub Pages**
- optional install via `scripts/install.sh`

Shared playbook (Converge + Sparky):

```text
../../../docs/macos-desktop-distribution.md
```

(from repo root: `../../docs/macos-desktop-distribution.md` when checked out under `codes/migration/converge`)

Absolute path on this machine:

```text
/Users/erickpatrickbarcelos/codes/docs/macos-desktop-distribution.md
```

## Canonical ownership

| Item | Value |
| --- | --- |
| Local path | `/Users/erickpatrickbarcelos/codes/migration/converge` |
| Git remote (this checkout) | `https://github.com/rckbrcls/converge.git` |
| Appcast that responds in production | `https://rckbrcls.github.io/converge/appcast.xml` |

### Known drift to clean up

Some files still mention the old `polterware/converge` owner or `polterware.github.io` URLs:

- `.github/workflows/release.yml` (`REPO`, `APPCAST_URL`)
- `converge/Info.plist` (`SUFeedURL`)
- `converge/Services/UpdateManager.swift` (hardcoded feed)
- `scripts/install.sh` (`REPO`)
- README / older docs

**Before the next production release**, align every reference to:

| Field | Target |
| --- | --- |
| GitHub repo | `rckbrcls/converge` |
| Appcast Pages | `https://rckbrcls.github.io/converge/appcast.xml` |
| Release ZIP host | `https://github.com/rckbrcls/converge/releases/...` |

Do not ship a release while workflow `REPO`, `SUFeedURL`, and `UpdateManager` disagree.

## Stack

| Piece | Path / value |
| --- | --- |
| Xcode project | `converge.xcodeproj` |
| Scheme / product | `converge` → `converge.app` |
| Sparkle | SPM + `Package.swift` pin |
| Updater code | `converge/Services/UpdateManager.swift` |
| Menu action | `Check for Updates…` in `converge/convergeApp.swift` (`AppCommands`) |
| Plist keys | `converge/Info.plist` → `SUFeedURL`, `SUPublicEDKey` |
| Appcast | `appcast.xml` |
| Appcast updater | `scripts/update_appcast.py` |
| Installer | `scripts/install.sh` |
| Keys helper | `scripts/generate-sparkle-keys.sh` |
| CI | `.github/workflows/release.yml` |
| Runner | `macos-26` |
| Secret | `SPARKLE_EDDSA_PRIVATE_KEY` |

## Release workflow

Trigger: GitHub Actions → **Release** → `workflow_dispatch` (optional `version` input overrides `CFBundleShortVersionString`).

Pipeline:

1. Checkout on `macos-26`
2. `CURRENT_PROJECT_VERSION = GITHUB_RUN_NUMBER`
3. `xcodebuild` Release, signing disabled
4. Verify `SUPublicEDKey` + `SUFeedURL` in built `Info.plist`
5. Strip signatures and ad-hoc `codesign`
6. Package `Converge-macos-universal-v{shortVersion}.zip` via `ditto`
7. Download Sparkle tools (`2.8.1`)
8. `sign_update` with `SPARKLE_EDDSA_PRIVATE_KEY`
9. `scripts/update_appcast.py` updates `appcast.xml` (enclosure → GitHub Release ZIP URL)
10. Generate release notes (`CHANGELOG.md` or `git log`)
11. Commit + push `appcast.xml`
12. Create/replace GitHub Release `v{shortVersion}` + upload ZIP
13. Publish `appcast.xml` to GitHub Pages

## Install

From a clone:

```bash
bash scripts/install.sh
bash scripts/install.sh --version 1.0.0
```

Installer behavior:

- Resolves latest or `v{version}` via GitHub API
- Prefers universal `.zip`
- Extracts with `ditto`, installs to `/Applications` or `~/Applications`
- Clears `com.apple.quarantine` when possible

Historical one-liner (may be stale — verify endpoint before publishing):

```bash
curl -fsSL https://converge-focus.vercel.app/install | bash
```

Prefer keeping the hosted install script byte-aligned with `scripts/install.sh` and `REPO=rckbrcls/converge`.

## In-app updates

- `UpdateManager` owns `SPUStandardUpdaterController`
- Daily interval (`86400`)
- Manual check from menu / settings / menu bar surfaces
- Feed URL must match the live appcast (plist + delegate)

## Signing reality

Current CI:

- builds unsigned
- re-signs **ad-hoc**
- **no** Developer ID
- **no** notarization

Gatekeeper may block first launch until right-click → Open. Do not claim notarized distribution.

## Pre-release checklist

- [ ] `REPO` / remotes / Pages URLs all say `rckbrcls`
- [ ] `SUFeedURL` == live appcast URL
- [ ] `UpdateManager` feed string == `SUFeedURL`
- [ ] `SUPublicEDKey` matches `SPARKLE_EDDSA_PRIVATE_KEY`
- [ ] Secret present on GitHub Actions
- [ ] Pages enabled (`build_type: workflow`)
- [ ] Smoke-test previous build → Check for Updates after shipping

## Rollback

No automated rollback.

Manual options:

1. Restore a known-good ZIP on the GitHub Release
2. Fix/replace the matching `appcast.xml` item (signature + URL + versions)
3. Redeploy Pages
4. Wait for clients to refresh the feed

## Related

- [Architecture](architecture.md) — update flow
- [Security](security.md) — keys, sandbox, installer trust
- [Troubleshooting](troubleshooting.md) — update/install failures
- Shared playbook: `/Users/erickpatrickbarcelos/codes/docs/macos-desktop-distribution.md`
