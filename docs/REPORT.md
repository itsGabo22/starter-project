# Applicant Showcase App: Final Report
**Applicant:** Gabriel (Gabo)  
**Role Applied For:** Junior Product Engineer  

---

### 1. Introduction
Stepping into the Applicant Showcase App project as a 5th-semester software engineering student, my initial feelings were a mix of deep excitement and healthy intimidation. The project presented a robust, production-grade tech stack that required a steep learning curve. From day one, my goal was not just to complete a checklist of requirements, but to approach the challenge with a product-centric mindset. I asked myself: *"What if Symmetry suddenly pivoted to become a high-end, exclusive reporting platform?"* This vision guided my architectural and design decisions, transforming a standard technical test into a comprehensive digital news experience that aligns with Symmetry's relentless pursuit of innovation.

### 2. Learning Journey
Before this project, my exposure to certain advanced architectural patterns was limited. I had to rapidly familiarize myself with the unidirectional data flow of Flutter BLoC, the strict layer isolation of Clean Architecture, and the nuances of NoSQL databases. 

The concept that demanded the most intense study was the **Separation of Concerns**. I researched how to keep the Presentation Layer completely agnostic of the business logic. I applied this knowledge by utilizing Dependency Injection, ensuring that my UI components (Cubits/BLoCs) only interacted with abstract `UseCases` rather than concrete data repositories. Furthermore, designing a scalable NoSQL document schema in Firestore taught me how to structure data flexibly while maintaining integrity through granular security rules.

### 3. Challenges Faced
The most significant obstacle I encountered was a severe framework conflict—a "Dependency Hell" involving version mismatches between code generators (`retrofit_generator` and `floor_generator`) and Dart 3 macros. 

This was a complex issue where even AI assistants struggled to provide a complete fix. Taking *Total Accountability* for the product's stability, I overcame this by diving deep into SDK constraints and executing tactical "emergency surgery" on the generated `.g.dart` files. I manually implemented a `fallbackToDestructiveMigration` to upgrade the SQLite database and applied a Unique Index on the `url` field to resolve constraint crashes. 

Additionally, I faced challenges with UI stability during network or emulator failures. I resolved this by enforcing Defensive Programming within the BLoC layer—wrapping repository calls in `try-catch` blocks to emit safe, empty states rather than leaving the user trapped in an infinite loading spinner.

### 4. Reflection and Future Directions
Technically, this project elevated my understanding of Data Orchestration and Domain Purity. Professionally, it shifted my mindset from a student completing an assignment to a Junior Product Engineer taking ownership of user experience and data integrity. 

Looking forward, the natural evolution of this project is bringing Artificial Intelligence directly into the article consumption ecosystem. My primary suggestion for future improvement is to fully materialize the "Ask AI" feature (Phase 5), transitioning it from a static UI teaser into a Context-Aware Intelligence Engine where an LLM is strictly grounded by the article's text to answer user queries.

### 5. Proof of the Project
*(Note for the reviewer: Click the links below to view the application in action).*

* **[Link to Video Demo: Full App Walkthrough & Emulators](https://youtu.be/eja1YGtUgh8)**
* **Screenshot 1:** Dark Mode Feed
 * ![WhatsApp Image 2026-03-30 at 5 01 37 PM](https://github.com/user-attachments/assets/39767f50-b669-4618-82b8-6ec90ed29529)

* **Screenshot 2:** Newspaper Mode Feed
* <img width="469" height="882" alt="Captura de pantalla 2026-03-30 165842" src="https://github.com/user-attachments/assets/49c8e87e-24ee-4383-9475-c0200e3d6fdb" />
* **Screenshot 3:** Article Detail & Ask AI
*  ![WhatsApp Image 2026-03-30 at 5 03 43 PM](https://github.com/user-attachments/assets/affc6255-c252-4337-b864-b8994afbc0df)

* **Screenshot 4:** Saved Articles & UI Stability
* ![WhatsApp Image 2026-03-30 at 5 04 57 PM](https://github.com/user-attachments/assets/08822dbc-9735-48f5-8d9d-407c99f0e0ee)

### 6. Overdelivery
To embody the core value to *Maximally Overdeliver*, I implemented several enhancements that push the application beyond the initial requirements:

#### 1. New Features Implemented:
* **The Newspaper Mode (Generational UX):** To solve the UI paradox of designing for a 90-year-old grandmother and an 18-year-old NPC, I created a highly accessible, dynamic theme. The Newspaper Mode uses strict Serif typography on a cream background. Most importantly, I applied a grayscale matrix filter to the images in the main feed to reduce cognitive load and emulate the broadsheet legacy. Believing that *Truth is King*, I defended this design choice to ensure aesthetic coherence and immersion, while deliberately preserving original image colors inside the Article Detail View.
* **Unified Feed via Data Orchestration:** Instead of isolating the NewsAPI and Firebase feeds, I built a `GetUnifiedArticlesUseCase`. It fetches both data streams, merges them, maps them to a single domain entity, and sorts them chronologically. This keeps Domain Purity intact without contaminating the UI with raw data structures.
* **Symmetry Exclusive Tagging:** I added an `isExclusive` boolean field to the Firestore schema. This visually highlights internal journalist articles with a "SYMMETRY EXCLUSIVE ⚡" badge, establishing a premium content tier.
* **Pro Editor & Global Dark Mode:** Added a real-time image preview, live word counter, shimmer loading effects, and fluid 60fps staggered animations for list rendering.

#### 2. Prototypes Created:
* **"Ask AI" Interface Prototype:** I designed a functional UI prototype for a contextual AI assistant. It includes a responsive Bottom Sheet integrated into the Article Detail view, setting the visual stage for interactive LLM integration.
* **Phase 4 & 5 Roadmap:** I documented the technical scaling blueprint in `docs/future_architecture/roadmap.md`, outlining the architectural implementation for Context-Aware AI, a Native Media Engine (Firebase Storage), and Global Vector Search (Algolia/ElasticSearch).

#### 3. How Can You Improve This:
The immediate next step for the Overdelivery section is the backend execution of the AI Prototype (Phase 5). This involves connecting the `google_generative_ai` package, injecting the specific article's content as a "System Instruction" to prevent hallucinations, and streaming the response back to the BLoC to create a real-time, interactive reading experience. 

### 7. Extra Sections
#### Code Snippet: Defensive BLoC Architecture & UI Stability
To ensure the app never hangs on a loading state due to database conflicts, the state management was fortified with explicit error handling during Phase 4:

```dart
// Snippet demonstrating defensive state emission to prevent infinite loading spinners
Future<void> _onGetSavedArticles(GetSavedArticles event, Emitter<LocalArticleState> emit) async {
  try {
    emit(const LocalArticlesLoading());
    final articles = await getSavedArticlesUseCase();
    emit(LocalArticlesDone(articles));
  } catch (e) {
    // Intercepts unhandled exceptions (e.g., SQLite migration failures, network drops)
    // Ensures the UI gracefully transitions to an error state rather than crashing.
    emit(const LocalArticlesError(message: "Unable to load saved articles at this time."));
  }
}
```
