# Resume — Cécile Morange

This repository contains the **source files and generated PDFs** of my professional resume,  
maintained in **Markdown** and built into **PDF** using Pandoc.

The goal is to keep a **single source of truth**, versioned, reproducible, and easy to maintain.

---

## 👤 About me

**Cécile Morange — Freelance Cloud Builder**

I design and operate **open-source virtualization infrastructures**,  
with a strong focus on **XCP-ng / Xen Orchestra**,  
datacenter operations and automation-driven platforms.

My background is strongly hands-on and spans across:
- Datacenter operations
- Open-source virtualization
- Infrastructure architecture & migrations
- Network design (BGP, OSPF)
- Linux systems & automation

I specialize in **VMware and XenServer exit strategies**, including  
**single and multi-datacenter environments**, with an emphasis on  
reliability, simplicity and operational efficiency.

---

## 📄 Contents

- `CV_Cecile_Morange_FR.md` — CV (French, Markdown source)
- `CV_Cecile_Morange_EN.md` — Resume (English, Markdown source)
- `assets/pdf/` — Generated PDF versions
- `generate-pdf.sh` — Build script for PDF generation

---

## 🛠️ Build PDFs

PDFs are generated using **Pandoc** and **XeLaTeX**.

### Requirements (Debian / Ubuntu)

```bash
sudo apt install pandoc texlive-xetex
