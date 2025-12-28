# Architecture Overview

## Vision & Motivation

The primary objective of this homelab is to provide a **self-sovereign, local-first environment** for studying Large
Language Model (LLM) integrations. By hosting the entire stack on-premise, I eliminate latency, subscription costs, and
data privacy concerns while simulating enterprise-grade workflows.

## The Technology Stack

| Component        | Choice              | Strategic Motivation                                                                                                                                                           |
|:-----------------|:--------------------|:-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **Orchestrator** | **K3s**             | Chosen to gain proficiency in **Kubernetes**, the industry standard for container orchestration. K3s provides a production-like environment with a minimal resource footprint. |
| **Inference**    | **Ollama**          | Serves as the local engine for open-source models (e.g., Llama 3), offering a robust API for integration without external dependencies.                                        |
| **Automation**   | **n8n**             | Acts as the "brain" of the operation, allowing the orchestration of complex AI agents and multi-step logic through a visual workflow interface.                                |
| **Messaging**    | **Openfire (XMPP)** | Provides a standardized, federated messaging protocol to test AI-to-Human communication in a real-time environment.                                                            |
| **Broker**       | **RabbitMQ**        | **Crucial Middleware:** Acts as the message broker for the `n8n-node-xmpp`, ensuring reliable delivery and decoupling the n8n logic from the XMPP connection.                  |
| **Frontend**     | **xmppweb**         | A modern web interface that allows for a seamless "Chat-style" experience using the local XMPP infrastructure.                                                                 |

---

## Technical Implementation

### Why this specific architecture?

My goal was to build a **sandbox** that mirrors corporate infrastructure. The choice of **K3s** ensures that the skills
I develop—such as managing deployments, services, and persistent volumes—are directly transferable to professional
DevOps roles.

In this ecosystem, **RabbitMQ** plays a vital role in stability. Since the `n8n-node-xmpp` community node utilizes it as
a backbone, RabbitMQ manages the message queues between my automation workflows and the **Openfire** server. This
prevents data loss during high-load inference tasks and allows for a resilient asynchronous architecture.

The integration flow is as follows:

1. **User Interaction:** The user sends a message via the **xmppweb** interface.
2. **Xmpp Handling:** **Openfire** captures the message, send to the bot account configured inside n8n workflow.
3. **Inference:** **n8n** processes the logic, queries **Ollama** for an LLM response, and handles any necessary
   tool-calling.
4. **Queueing:** **n8n-node-xmpp** queue the message responses, via **RabbitMQ**.
5. **Delivery:** **n8n-node-xmpp** get messages from the queue and send response back through the XMPP node to the user.

This setup is the ultimate playground for studying **RAG (Retrieval-Augmented Generation)**, autonomous agents, and API
security in a completely **off-grid** scenario."

---

## Key Learning Objectives

* **Kubernetes Mastery:** Managing a cluster, namespaces, networking, deployments, ingress routes, and pretty much
  everything related to kubernetes ecosystem using K3s.
* **AI Orchestration:** Designing autonomous workflows that bridge local LLMs with communication protocols.
* **Protocol Standards:** Exploring XMPP as an alternative to proprietary messaging APIs for AI deployment.
