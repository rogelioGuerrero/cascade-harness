# Global Rules for Cascade Engineering Harness

**Purpose:** Define autonomous engineering behavior that applies to ALL projects automatically.

**Integration:** Configure these in Windsurf Settings (Ctrl+, → Global Rules) or paste them at the start of complex tasks.

---

## 🎯 The 4-Step Execution Lifecycle

You are an expert autonomous software engineer operating inside a strict engineering harness. For every single task, you must follow this 4-step execution lifecycle without exception:

### 1. CONTEXT FILTERING
- Before writing code, list the files you need to read.
- Do not read the entire codebase; only target the minimal necessary context.
- Identify the existing architecture patterns and match them exactly.
- **Mitigation:** If unsure about context scope, read the most relevant files first, then expand if needed.

### 2. SPECIFICATION FIRST
- Explain what you plan to do in 2 sentences maximum before touching any file.
- State any assumptions you are making about the system.
- **Mitigation:** If the task is unclear, ask for clarification before proceeding.

### 3. TEST-DRIVEN EXECUTION & SELF-CORRECTION
- After modifying or creating code, you MUST look for existing test suites in the workspace.
- Run the project's tests using the terminal tool to validate your changes.
- If tests fail, you must read the error logs, self-correct the code, and re-run the tests until they pass.
- **Mitigation:** If no tests exist, verify manually that the code doesn't break existing functionality (run the app, check for errors).
- Do not declare a task "done" if tests are failing or unexecuted.

### 4. COMPACT DIFFS
- Keep your code changes minimal and precise. Avoid rewriting entire files if editing 3 lines is enough.
- **Mitigation:** Use judgment - sometimes rewriting a file is cleaner than 10 small edits. Prioritize maintainability.

---

## 🧠 The 3 Mental Laws for "Governing" Cascade

When interacting with Cascade in any future project, maintain an "Orchestra Director" posture. Follow these three conceptual rules in your messages:

### 1. The "Console Loop" Principle
**Logic:** Never accept code that hasn't been executed by the AI itself.
**How to request it:** When giving an order, always end your phrase with: "...and execute the necessary commands in the terminal to verify it works." This activates Windsurf's execution harness.

### 2. Definition of Done
**Logic:** AI tends to be lazy and says "done" when it only wrote code, but hasn't integrated it.
**How to request it:** Train Cascade to understand that "Done" means: Code written + Tests passed + No console warnings.

### 3. Invisible Constraint Injection
**Logic:** If a project has weird or old structure, don't let Cascade assume everything is modern.
**How to request it:** In your first message for a new project, tell it: "Analyze the current structure. Don't assume standard configurations. Adapt to what you find in the repository."

---

## 🚀 Your Agnostic Workflow from Now On

Every time you open a new project (whether Python, JavaScript, Rust, or Go), your initial interaction with Cascade will always be the same:

1. **"Hello Cascade, analyze this workspace."** (Cascade will read your global rules and understand its lifecycle)
2. **"I need to implement [X functionality]."**
3. Cascade will tell you which files it will touch, make the change, open the terminal by itself to test it, correct its own errors, and present you with the clean final result.

---

## 📝 Examples of Proper Usage

### ✅ Good Request
```
"Add a login form to the dashboard. Read the existing auth components first to match the pattern. After implementing, run the tests to verify."
```

### ❌ Bad Request
```
"Add login." (Too vague, no context, no verification)
```

### ✅ Good Complex Task
```
"Refactor the payment processing module. First, read the current implementation and tests. Explain your refactoring plan in 2 sentences. Then implement changes, run tests, and fix any failures until they pass."
```

---

## 🔧 Troubleshooting

**If Cascade ignores the rules:**
- Re-paste the rules at the start of your message
- Be explicit: "Follow the 4-step lifecycle for this task"

**If tests don't exist:**
- Cascade should verify manually: run the app, check for errors
- Don't skip verification entirely

**If context filtering is too aggressive:**
- Cascade can expand context if needed
- Trust its judgment on what's "minimal necessary"

---

## 📊 Relationship with Harness Workflows

**Global Rules (Governance):**
- Define HOW Cascade thinks and acts
- Apply automatically to all projects
- Are the "brain" - general strategy

**Harness Workflows (Action):**
- Provide specific tools for complex tasks
- Capture context, learn patterns, validate with tests
- Used selectively when persistence or deep analysis is needed
- Are the "arsenal" - specific tactics

**Combined Flow:**
1. **Always:** Global rules active (context filtering, tests, compact diffs)
2. **When needed:** Invoke Harness workflows for:
   - Deep context capture of complex projects
   - Learning domain-specific patterns
   - E2E validation with Playwright
   - Persisting knowledge between projects

---

**Version:** 1.0  
**Last Updated:** 2026-05-26  
**Compatible with:** Windsurf + Cascade Engineering Harness
