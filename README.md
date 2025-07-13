# 📊 Data Analytics Assessment – SQL

This repository contains SQL scripts used for analyzing **user behavior**, **transactions**, and **customer value** across a large-scale **financial dataset**. The objective was to demonstrate practical data analytics skills through **data cleaning**, **transformation**, and **business metric calculations**.

---

## 🧠 Project Overview

This SQL-based assessment tested my ability to work with a **complex, multi-table schema** involving financial products. The focus was on:

- Cleaning dirty or invalid data  
- Segmenting users by behavioral traits  
- Identifying inactive plans  
- Calculating Customer Lifetime Value (CLV)

---

## 📁 Files Included

| File Name                         | Description                                         |
|----------------------------------|-----------------------------------------------------|
| `Assessment Q1.sql`              | Question 1 – Data Cleaning                         |
| `Assessment Q2.sql`              | Question 2 – Frequency Segmentation                |
| `Assessment Q3.sql`              | Question 3 – Inactive Plans Detection              |
| `Assessment Q4.sql`              | Question 4 – Customer Lifetime Value Calculation   |
| `plans table data cleaning.sql`  | Cleaning logic for the `plans` table               |
| `savings table data cleaning.sql`| Cleaning logic for the `savings` table             |
| `user table data cleaning.sql`   | Cleaning logic for the `user` table                |
| `withdrawal table data cleaning.sql`| Cleaning logic for the `withdrawal` table       |
| `README.md`                      | This file – project description and reflections    |

---

## 💡 My Experience

This was my **first real SQL assessment**, and honestly, the schema was intimidating:

- `plans`: 56 columns  
- `savings`: 37 columns  
- `user`: 57 columns  
- `withdrawal`: 23 columns  

At first, I was stuck. But my “never give up” mindset kicked in. I didn’t rush into writing queries. I **analyzed the schema**, **understood relationships**, and **documented everything** on pen and paper before diving in.

---

## 🧹 Data Cleaning Approach

Before writing any analytical queries, I cleaned each table **separately** using a **soft filtering** technique by adding an `is_deleted` flag:

- `0` → Valid row  
- `1` → Invalid / flagged row  

### 🧼 Cleaning Logic Summary

#### ✅ Plans Table
- Removed duplicate IDs  
- Checked nulls in foreign keys  
- Removed future/null start dates  
- Flagged 0 or negative investment amounts (based on `is_fund`)  
- Standardized boolean flags  
- Detected test/dummy data  
- Validated start/end date logic  

#### ✅ User Table
- Handled nulls in key fields  
- Flagged future `join_date` / `birth_date`  
- Removed dummy/test users  
- Flagged potential fraud-risk users  
- Invalid geo-coordinates handled  

#### ✅ Savings Table
- Removed future transaction/maturity dates  
- Flagged suspicious/negative savings  
- Skipped overly aggressive filtering to avoid data loss  
- Invalid/missing fees flagged  

#### ✅ Withdrawal Table
- Flagged nulls in key fields  
- Removed negative withdrawals  
- Handled invalid dates and dummy/test rows  
- Checked broken business logic  

> 🧠 The `savings` table was the **messiest**. Took the most time and taught me how critical clean data is.

---

## 📝 Per-Question Explanations

### Q1: Data Cleaning
- Cleaned all 4 tables with a consistent `is_deleted` logic  
- Avoided hard deletes to preserve traceability

### Q2: Frequency Segmentation
- Grouped transactions by user  
- Calculated average monthly savings  
- Classified users into: **High**, **Medium**, and **Low Frequency**

### Q3: Inactive Plans
- Identified active/inactive savings plans  
- Plans with **no transaction in last 12+ months** were flagged

### Q4: Customer Lifetime Value (CLV)
- Calculated user tenure in months  
- Estimated avg monthly contribution  
- Used:  
  `CLV = (Monthly Transactions × 12) × Avg Profit Per Transaction`

---

## 🚧 Challenges & How I Tackled Them

| Challenge                         | How I Solved It                                        |
|----------------------------------|--------------------------------------------------------|
| Large schema + too many columns | Broke it into chunks, noted down structure manually   |
| Dirty/messy savings table        | Less aggressive filtering to avoid data loss          |
| Soft filtering via `is_deleted` | Helped me track what’s invalid without removing rows  |
| Financial domain unfamiliarity   | Used Google + ChatGPT + logic + common sense          |

---

## 🛠️ Tech Stack

- **SQL** – MySQL-compatible syntax  
- **Pen & Paper** – For breaking down schema  
- **GitHub** – Version control and documentation

---

## 👨‍💻 Author

**Avik Sarkhel**  
🎓 MCA Student | Aspiring Data Analyst  
📍 Based in Kolkata, India  
📫 [avik305sarkhel@gmail.com](mailto:avik305sarkhel@gmail.com)  
🔗 [LinkedIn – Avik Sarkhel](https://www.linkedin.com/in/avik-sarkhel)

---

## ✨ Final Words

This assessment wasn’t just a test — it was a **level-up moment**.  
I learned:

- How much **cleaning** affects analysis  
- How to approach **complex schemas**  
- That SQL isn’t just about SELECTs, it’s about **logic** and **business thinking**

> 💡 It’s okay to feel lost at first. Start small. Think clearly. The answers are always in the data.

---

> ⭐ If this project helped you or inspired your own SQL learning journey, drop a ⭐ and connect!
