# Xord — Security Policy

[Bahasa Indonesia](README.md) · [English](README.en.md)

## Supported version / Versi yang didukung

The current public stable distribution is **Xord v1.1.3 (Windows x64)**. UI v1.2.0 remains in development; do not treat preview builds as a supported public release.

## Private vulnerability reporting / Pelaporan kerentanan

Do not include passwords, API tokens, certificates containing private keys, personal academic documents, exploit payloads, or unredacted logs in a public issue.

Jika menemukan kerentanan, gunakan **private vulnerability reporting** pada GitHub jika tersedia. Jika belum tersedia, buat issue singkat dengan kategori dan dampaknya **tanpa detail eksploitasi atau data sensitif**, lalu minta jalur komunikasi privat.

If you discover a security issue, use GitHub's private vulnerability reporting when available. Otherwise submit only a minimal, non-sensitive issue requesting a private disclosure channel.

## Release integrity / Integritas rilis

Official releases should provide:
- the Windows x64 release bundle;
- the public signing certificate when MSIX trust setup requires it;
- `SHA256SUMS.txt`;
- release notes.

Verify the downloaded ZIP with [Verify-Xord.ps1](scripts/Verify-Xord.ps1) and its corresponding manifest. **Private signing keys must never be included in a public release or a public issue.**

## Data privacy / Privasi data

Xord manages academic project files locally. Do not publish project files containing student data, citations with private attachments, supervisors' contact details, or other sensitive information without authorization.

## Repository scope

This repository currently serves **public distribution, documentation and support**. Full internal development source and private signing/build infrastructure are not automatically published to this public repository.

## Responsible disclosure

Avoid performing destructive tests on other people's machines, uploading private data, or sharing a proof of concept publicly before a confidential reporting route is established.
