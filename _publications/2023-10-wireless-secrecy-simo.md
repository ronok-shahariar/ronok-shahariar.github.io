---
title: "Analyzing Secrecy Performance in Wireless Communication Networks with Randomly Distributed Eavesdroppers"
collection: publications
category: manuscripts
permalink: /publication/2023-wireless-secrecy-simo
excerpt: 'Unified physical layer security (PLS) framework for dual-hop SIMO decode-and-forward relay networks over generalized alpha-mu fading channels subject to Poisson-distributed eavesdroppers across three operational attack models.'
date: 2023-09-30
venue: 'Undergraduate Thesis, Rajshahi University of Engineering & Technology (RUET)'
paperurl: '/files/Thesis_Shahariar_Ronok_RUET.pdf'
citation: 'M. K. Kundu and MD. Shahariar Hassan, "Analyzing Secrecy Performance in Wireless Communication Networks with Randomly Distributed Eavesdroppers," B.Sc. Thesis & Working Manuscript, Dept. of ECE, Rajshahi University of Engineering & Technology (RUET), Sept. 2023.'
---

## Overview & Executive Summary

In next-generation wireless communications (5G NR, 6G, UWB, LoRaWAN), the broadcast nature of the wireless medium exposes data transmissions to unauthorized interception. Conventional physical-layer security (PLS) evaluations frequently rely on simplistic assumptions—either static eavesdropper coordinates or idealized single-hop links under classical Rayleigh/Nakagami fading.

This research establishes a **generalized analytical PLS framework** for dual-hop **Single-Input Multiple-Output (SIMO)** decode-and-forward (DF) relay networks over **$\alpha$-$\mu$ generalized fading channels**, where non-colluding eavesdroppers are spatially dispersed according to a homogeneous **Poisson Point Process (PPP)** with spatial density $Z_e$.

---

## Operational Attack Paradigms

We formulated and solved closed-form expressions for three distinct eavesdropping topologies:

1. **Scenario I (Source-Hop Interception):** Eavesdroppers intercept confidential transmissions solely from the source ($S \to R$ link). The relay-to-destination hop ($R \to D$) remains uncompromised.
2. **Scenario II (Relay-Hop Interception):** The $S \to R$ link is secure, while eavesdroppers actively target the relay transmissions ($R \to D$ link).
3. **Scenario III (Simultaneous Dual-Hop Interception):** Both the source and relay hops undergo concurrent, independent wiretapping attacks by distributed adversaries—representing the most severe vulnerability profile.

---

## Mathematical Formulation & Closed-Form Solutions

### 1. Channel Statistics under $\alpha$-$\mu$ Fading
For a SIMO link with $M$ receiving antennas, fading parameter $\alpha_r$, and normalized variance parameter $\mu_r$, the Probability Density Function (PDF) of the instantaneous SNR $x$ is:

$$f_{sr}(x) = \beta_1 x^{\beta_2} e^{-\beta_3 x^{\bar{\alpha}_r}}$$

Where $\bar{\alpha}_r = \frac{\alpha_r}{2}$, $\beta_1 = \frac{\bar{\alpha}_r (M \mu_r)^{M \mu_r}}{\Gamma(M \mu_r)(M \bar{x}_r)^{M \mu_r \bar{\alpha}_r}}$, and $\beta_2 = M \mu_r \bar{\alpha}_r - 1$.

### 2. Spatial Modeling of Distributed Eavesdroppers (PPP)
In a 2D Euclidean space ($d=2$) with path loss exponent $\nu$ and spatial density $Z_e$, the PDF of the received wiretap SNR for the $k$-th eavesdropper is formulated as:

$$f_{se}(x) = \beta_8 x^{\beta_9} e^{-\beta_{10} x^{-\lambda}}, \quad \text{where } \lambda = \frac{d}{\nu}$$

### 3. Unified Secrecy Metrics Derived via Meijer's G-Functions
By transforming product integrals of generalized exponential kernels and power terms into Meijer's G-functions ($G_{p,q}^{m,n}$), we derived exact closed-form expressions for:

* **Secrecy Outage Probability (SOP):**
  $$SOP = \int_{0}^{\infty} F_{legitimate}(x) f_{wiretap}(x) \, dx$$
  *Evaluated for Scenario III as $SOP_3 = S_1 + S_2 - S_1 S_2$, where $S_1$ and $S_2$ denote individual hop outages.*
* **Strictly Positive Secrecy Capacity (SPSC):** Evaluates non-zero positive secrecy capacity simultaneously across both hops ($SPSC_3 = (1-\mu_1)(1-\mu_2)$).
* **Intercept Probability (IP):** Complement of strictly positive capacity ($IP = 1 - SPSC$).
* **Effective Secrecy Throughput (EST):** Penalized confidential data rate under outage probability:
  $$EST = R_s \times (1 - SOP)$$

---

## Key Findings & Research Insights

* **Mitigating Distributed Threats via Array Gain:** Equipping the relay ($M$) and destination ($M_1$) with multiple receiving antennas creates substantial array gain that counterbalances multi-antenna eavesdropper interception capabilities ($p \ge 1$).
* **The Asymmetric Bottleneck:** In asymmetric antenna configurations ($M > M_1$), Scenario I yields significantly stronger secrecy performance than Scenario II, proving that network secrecy is constrained by the weakest hop.
* **Validation:** All analytical derivations were corroborated across multiple channel configurations ($\alpha, \mu$) using comprehensive **Monte Carlo simulations** executed in MATLAB and Mathematica.

---

## Artifacts & Thesis Documentation

* **Manuscript:** [Download Full Thesis Book (PDF)]({{ page.paperurl }})
* **Supervisors:** 
  * **Milton Kumar Kundu**, Assistant Professor, Dept. of ECE, RUET
  * **Dr. Md. Rabiul Islam**, Professor, Dept. of CSE, RUET


## Read Manuscript Online

<div style="width: 100%; height: 800px; margin: 20px 0; border: 1px solid #e2e8f0; border-radius: 8px; overflow: hidden; box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);">
  <iframe 
    src="{{ page.paperurl }}" 
    width="100%" 
    height="100%" 
    style="border: none;">
    <p>Your browser does not support inline PDF viewing. <a href="{{ page.paperurl }}">Click here to download the PDF</a> instead.</p>
  </iframe>
</div>