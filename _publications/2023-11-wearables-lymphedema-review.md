---
title: "A Review on Wearable Technologies in Early Detection of Lymphedema"
collection: publications
category: manuscripts
permalink: /publication/2023-wearables-lymphedema-early-detection
mathjax: true
excerpt: 'Comprehensive scoping review examining wearable biosensing modalities—force-sensitive resistors, epidermal strain/dielectric sensors, and ultrasonic time-of-flight transducers—for continuous, non-invasive early detection of lymphedema.'
date: 2023-11-01
venue: 'Department of Electrical & Computer Engineering, RUET'
paperurl: '/files/Review_Wearables_Lymphedema_Ronok.pdf'
citation: 'Shahariar H. Ronok, "A Review on Wearable Technologies in Early Detection of Lymphedema," Working Manuscript & Scoping Review, Dept. of Electrical & Computer Engineering, Rajshahi University of Engineering & Technology (RUET), 2023.'
---

## Executive Summary

Lymphedema is a debilitating chronic condition characterized by the localized accumulation of protein-rich lymphatic fluid, primarily affecting the upper or lower limbs following cancer therapies (e.g., axillary lymph node dissection, radiation). While early detection is critical to halt irreversible tissue fibrosing, conventional diagnostic modalities—such as perometry, water displacement, and tape measurements—suffer from clinic-visit dependency, operator error, and lack of real-time trend capture.

This review provides a systematic engineering evaluation of emerging **wearable sensor platforms**, **digital twin simulators**, and **embedded edge processing architectures** designed to achieve continuous, real-time remote monitoring of fluid volume shifts.

---

## Key Biosensing Modalities Analyzed

The review investigates state-of-the-art non-invasive sensor paradigms explored in recent biomedical literature:

1. **Force-Sensitive Resistors & Circumferential Cuffs:**
   * Evaluating dynamic pressure response and ankle/limb radius of curvature variations using context-aware, low-power FSR sensors (e.g., Smart-Cuff platforms achieving $>96\%$ physical state classification accuracy).
2. **Conformal Epidermal Dielectric & Strain Patches:**
   * Analyzing wireless multi-functional skin-interfaced epidermal sensors capable of simultaneous hydration profiling and mechanical deformation sensing.
   * Mitigating tissue moisture cross-sensitivity on resonant frequency via dual LC tank circuits:
     $$f = \frac{1}{2\pi\sqrt{LC}}$$
3. **Ultrasonic Time-of-Flight (ToF) & Acoustic Sensing:**
   * Investigating portable ultrasound transducers combined with external magnetic reference sensors to gauge tissue thickness and sound velocity:
     $$v = \frac{d}{TOF}$$
   * Directly estimating muscle and soft-tissue water content changes within biological tissue phantoms.
4. **Digital Twins & Statistical Change-Point Protocols:**
   * Incorporating growth models (Logistic, Gompertz, von Bertalanffy) paired with non-parametric change-point algorithms (Mann-Kendall, Pettitt's tests) to establish clinical thresholds prior to visible edema manifestation.

---

## Critical Challenges & Engineering Bottlenecks

* **Motion Artifacts & Context Dependency:** Differentiating posture-induced hydrostatic fluid shifts from pathologic lymphatic fluid accumulation requires tight coupling with on-body inertial measurement units (IMUs).
* **Power Constraints & Battery Life:** Continuous edge sampling demands energy-efficient derivative-free heuristic sampling algorithms and low-power Bluetooth Low Energy (BLE) transmission schemes.
* **Form Factor & Long-Term Adhesion:** Moving beyond rigid breadboards toward breathable, biocompatible e-textiles and stretchable elastomeric substrates that maintain conformal skin contact without aggravating sensitive lymphedematous tissue.

---

## Artifacts & Manuscript Details

* **Author:** **Shahariar H. Ronok** (Dept. of ECE, RUET)
* **Full Text:** [Download Review Paper (PDF)]({{ page.paperurl }})

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