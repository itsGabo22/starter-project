# 🚀 Project Roadmap: The Symmetry Era (Phase 4 & Beyond)

This document outlines the technical and architectural vision for scaling the "Daily News" application into an industrial-grade product, aligned with **Symmetry**'s high standards.

## 🧠 Component 1: Deep-Dive AI (Interactive Context)
Currently, Gemini acts as a static formatter. The logical evolution is to transform it into a **Deep-Context Assistant**.

- **Proposed Feature:** Integrate a side panel in the article detail view allowing users to chat directly about the content.
- **Technical Approach:** Implement *Contextual Injected Prompting* where article content is sent as a `systemInstruction`, forcing the AI to respond solely based on the text's truth ("Truth is King").
- **Value Added:** Dynamic voice summaries for accessibility (The 90-year-old grandmother) and instant translation into 50+ languages.

## 🖼️ Component 2: Native Media Engine
Current image management is limited to external URLs. For total product control, a proprietary media engine is required.

- **Integration:** **Firebase Cloud Storage**.
- **Functionality:** Implement native image uploads from the Journalist Editor with automatic client-side compression (using the `image` package).
- **Architecture:** Generate *Signed URLs* with expiration times to enhance asset security.

## 🔍 Component 3: Global Precision Search
With a massive unified feed, linear search is insufficient.

- **Proposed Feature:** Integration of **Algolia** or **ElasticSearch**.
- **Implementation:** Synchronize NewsAPI and Firestore news into a vector search index to allow semantic similarity searches, not just keyword matching.

## ⚙️ Architectural Vision (Scalability)
To support millions of concurrent users, we propose:

1.  **Multi-Region Firestore:** Deploy database clusters close to the end-user for <50ms latency.
2.  **Automated CI/CD:** Integration with GitHub Actions for continuous deployments with integration tests validating the full journalist workflow.
3.  **Total Modularization:** Migrate towards a *Micro-frontends* or internal packages model to allow UI and Core teams to work without merge conflicts.



# 🧠 Phase 5 & Beyond: The Intelligence Era (Deep-Dive AI)

## 🚀 Vision: Interactive Contextual Intelligence
The "Ask AI" feature will evolve from a high-fidelity teaser to a **Context-Aware Intelligence Engine**. The goal is to allow users to have a real-time dialogue with any article, anchored strictly by the article's text.

### 🏛️ Architectural Implementation (Clean Architecture)
To preserve **Domain Purity**, we will implement the following:

- **Entity Layer:** Introduction of `ChatMessageEntity` and `ChatSessionEntity` to manage local conversation history.
- **UseCase Layer:** `GetAIContextualResponse` will orchestrate the flow between the user's query and the Gemini API.
- **Data Layer (Contextual Prompting):** - Implement **System Instructions** to ground the LLM: *"Your only source of truth is [Article Content]. Answer only based on this text."*
    - Integration of `google_generative_ai` for low-latency streaming responses.

### 🎨 Presentation Layer: Reactive & Adaptive UI
- **BLoC Orchestration:** `AIChatBloc` will manage the message stream and "Typing" states.
- **Adaptive UX:**
    - **Dark Mode:** Futuristic Glassmorphism chat bubbles.
    - **Newspaper Mode:** Rectangular "Letters to the Editor" style layout with strict Serif typography to maintain the broadsheet immersion.

### 🛡️ Safety & Optimization
- **Token Management:** Implementation of text truncation and sliding window context to stay within API limits.
- **Debouncing:** Rate-limiting user queries to ensure cost-efficiency and prevent API abuse.

---
*Document prepared by the Symmetry Standard Engineering Team.*