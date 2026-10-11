# Xord — Installation / Instalasi

[README Bahasa Indonesia](README.md) · [English README](README.en.md)

## Versi yang didukung / Supported release

**Xord stable v1.1.3 — Windows 10/11 x64.** UI v1.2.0 is still under development and is not the public stable installer.

Rilis lama dapat mempertahankan **nama paket dan identitas installer historis**. Hal tersebut tidak mengubah nama produk Xord maupun berkas proyek yang sudah dibuat.

## Instalasi manual / Manual installation

1. Buka / Open [Latest release](https://github.com/zyxel-lyn/Xord/releases/latest).
2. Unduh arsip Windows x64 dan file `SHA256SUMS.txt` dari rilis yang sama. / Download the Windows x64 archive and matching checksum manifest.
3. Verifikasi SHA-256 / Verify the archive:

```powershell
.\scripts\Verify-Xord.ps1 -ZipPath ".\downloaded-Windows-x64.zip" -ChecksumsPath ".\SHA256SUMS.txt"
```

Ganti path ZIP dengan nama berkas sesungguhnya. / Use the archive's actual file name.

4. Ekstrak arsip. / Extract the archive.
5. Jalankan PowerShell sebagai Administrator di folder hasil ekstraksi. / Run elevated PowerShell in the extracted folder.
6. Jalankan **skrip instalasi yang disertakan dalam paket rilis**. / Run the installation script shipped inside the archive. Historic packages may retain their original installer filename.
7. Buka aplikasi dari Start Menu. / Launch the installed app from the Start Menu.

## Instalasi otomatis / Installer helper

Review the helper script before running it. Administrator privileges are required for MSIX certificate trust.

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\scripts\Install-Xord.ps1
```

The helper resolves the latest release on `zyxel-lyn/Xord`, downloads the Windows x64 archive plus `SHA256SUMS.txt`, verifies SHA-256, extracts the package into an isolated temporary folder, then launches its bundled installer. Temporary downloads are cleaned up **only after successful installation**. Use `-KeepDownloads` to retain files after success.

**Important:** The new helper has passed PowerShell syntax and local checksum/tamper tests. The complete release-install and certificate-trust flow has **not yet been revalidated end-to-end on a second machine**. A successful cryptographic check does not establish that every MSIX package is trusted by Windows.

## Uninstall / Hapus aplikasi

Use Windows **Settings → Installed apps** for the existing installation. The app's display name in older releases may reflect its release-time identity. Avoid deleting user project files when uninstalling.

## Troubleshooting

**PowerShell policy:** Use `Set-ExecutionPolicy -Scope Process Bypass` in the current PowerShell process; this does not permanently alter system policy.

**Certificate warning:** Use the installer bundled with the verified release in an elevated PowerShell window. The installer handles the public signing certificate trust step.

**Installation failure:** Keep the output and report a reproducible issue without uploading passwords, private project documents, certificates with private keys, or account secrets.

**Existing projects:** A product rename must not overwrite, reset or silently migrate the user's existing local project files. The project-file compatibility contract remains in effect.

## Safety

Do not use third-party mirrors or replace MSIX DLLs from untrusted download websites. Download from the official GitHub Releases page and verify the matching manifest.

[Security policy](SECURITY.md) · [Report a problem](https://github.com/zyxel-lyn/Xord/issues)
