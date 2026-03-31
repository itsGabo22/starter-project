# 🚀 Project Roadmap: The Symmetry Era (Scalability & Multi-Platform Vision)

This document outlines the technical and architectural vision for scaling the "Applicant Showcase App" into an industrial-grade product, aligned with **Symmetry**'s high standards. With Phase 5 (Consumer AI) and Phase 6 (Creator AI) fully implemented on the client, the next engineering cycle focuses on cross-platform ubiquity and profound Backend AI Orchestration.

> **💡 Vision for the Future:** This application has been structurally engineered to scale across multiple dimensions—from infrastructure backends to new user platforms. I have conceptualized several grand ideas to continue expanding this ecosystem, ensuring that the product can seamlessly grow to support millions of users and new generative AI capabilities.

---

## 🌐 Component 1: True Cross-Platform Ubiquity
The current application successfully targets Windows Desktop and Android emulation. The evolutionary step is making this ecosystem a *True Cross-Platform* powerhouse.

- **Objective:** Deploy a unified codebase for Web (Google Chrome), Windows (Native Desktop), and Native Mobile (iOS/Android).
- **Web Migration Strategy (Chrome):** 
  - To support Web browsers securely, we must overcome strict CORS policies. This requires decoupling direct external API calls (currently executed via the Flutter client) by passing all traffic through an internal backend proxy route.
  - Implement progressive web app (PWA) functionality to allow offline caching for readers in low-connectivity zones.
- **Native Mobile Execution:**
  - Inject environment-specific configuration variables via `dart-define` for distinct iOS/Android build flavors.
  - Ensure Deep Linking is implemented to allow journalists to share articles natively via social media, which opens symmetrically on the app.

## 🧠 Component 2: Bimodular AI Operations Migration (Backend)
Currently, AI interactions (Gemini API) are securely localized in the `Data Layer` on the frontend for prototyping. In a production environment, this is unacceptable due to the risk of API key extraction.

- **Proposed Feature:** Migrate all AI System Instructions and token logic into **Firebase Cloud Functions (Node.js/Python)**.
- **Technical Flow:** 
  1. The Flutter client invokes a Cloud Function endpoint: `POST /enhanceText` or `POST /oracleChat`.
  2. The Cloud Function securely retrieves the API secret from Google Cloud Secret Manager.
  3. The Backend interacts with the LLM, parses the response, and returns pure sanitized text to the client.
- **Value Added:** 
  - Absolute API Key protection.
  - Granular control over Rate Limiting and Token Quotas at a server level.
  - Ability to seamlessly inject RAG (Retrieval-Augmented Generation) databases to make the Oracle smarter without bloating the client app.

## 🖼️ Component 3: Native Proprietary Media Engine
Current image management is limited to external URLs. For total product control, a proprietary media engine is required to ensure users don't break external hotlinks.

- **Integration:** **Firebase Cloud Storage**.
- **Functionality:** Implement native image uploads from the Journalist Editor with automatic client-side isolate-based compression (using the `image` package) before upload.
- **Architecture:** Generate *Signed URLs* with expiration times to enhance digital asset security and track asset usage.

## ⚙️ Architectural Vision (Global Infrastructure)
To support millions of concurrent news readers across Web, Windows, and Mobile:

1.  **Multi-Region Firestore Clusters:** Deploy database clusters on edge nodes precisely aligned with Symmetry's demographic to guarantee <50ms read latency for breaking news.
2.  **Automated CI/CD Pipelines:** Implement GitHub Actions that orchestrate static analysis (`dart analyze`), unit testing, and automated binary compilations for Web `.wasm`, Windows `.exe`, and Android `.apk`. 
3.  **Modularized Feature Packages:** Transition from folder-based Clean Architecture to a *Melos Monorepo* architecture (Micro-frontends model). The AI engine, the feed, and the core network logic will exist as decoupled internal `pub` packages, enabling specialized engineering pods to work completely asynchronously without merge conflicts.

---
*Document prepared by the Symmetry Standard Engineering Team.*