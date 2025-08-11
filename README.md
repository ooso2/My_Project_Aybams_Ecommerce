# README

# AYBAMS E-commerce Platform

![AYBAMS Logo](https://app/assets/images/aybams-logo.png)

**Sustainable Home Goods & Lifestyle Products**

---

## Table of Contents

- [Project Overview](#project-overview)  
- [Features](#features)  
- [Technical Specifications](#technical-specifications)  
- [Getting Started](#getting-started)  
  - [Prerequisites](#prerequisites)  
  - [Installation](#installation)  
- [Configuration](#configuration)  
- [Database Setup](#database-setup)  
- [Testing](#testing)  
- [Deployment](#deployment)  
- [Project Management](#project-management)  
- [License](#license)  

---

## Project Overview <a name="project-overview"></a>

AYBAMS is a specialty retailer focused on sustainable home goods and lifestyle products. This Rails e-commerce platform enables AYBAMS to expand their reach across Canada while maintaining their commitment to sustainable business practices.

### Key Business Goals

- Expand online sales across Canada  
- Showcase product sustainability stories  
- Maintain ethical sourcing standards  
- Provide educational content on eco-friendly living  

### Technical Objectives

- Robust inventory management  
- Multi-channel fulfillment support  
- Historical price accuracy  
- Seamless checkout experience  

---

## Features <a name="features"></a>

### Core Functionality

- Admin dashboard with product and category management  
- Product catalog with category navigation and pagination  
- Product detail pages with images and descriptions  
- Shopping cart with quantity management  
- User authentication with secure password storage (Devise)  
- Checkout process with Stripe payment integration  
- Order history for customers  
- Tax calculation by province  

### Advanced Features

- Price history tracking  
- Responsive design for all devices  
- Active Storage with AWS S3 integration  
- Search functionality by category  
- SASS/SCSS styling using Bootstrap framework  
- Docker containerization for easy deployment  

---

## Technical Specifications <a name="technical-specifications"></a>

| Component             | Technology                  |
|-----------------------|----------------------------|
| Ruby Version          | 3.2.2                      |
| Rails Version         | 7.0.4                      |
| Database              | PostgreSQL 14+             |
| Frontend              | Bootstrap 5, Hotwire, SCSS |
| Authentication        | Devise                     |
| Payment Processing    | Stripe API                 |
| Image Storage         | Active Storage with AWS S3 |
| Testing               | RSpec, Cypress             |
| Deployment            | Heroku, Docker             |

### System Dependencies

- Ruby 3.2.2  
- Rails 7.0.4  
- PostgreSQL 14+  
- Node.js 16+  
- Yarn  
- Redis (for caching)  

---

## Getting Started <a name="getting-started"></a>

### Prerequisites <a name="prerequisites"></a>

Ensure the following are installed:

- Ruby 3.2.2  
- PostgreSQL 14+  
- Node.js 16+  
- Yarn  

### Installation <a name="installation"></a>

```bash
# Clone the repository
git clone https://github.com/your-username/aybams_project_app.git
cd aybams_project_app

# Install dependencies
bundle install
yarn install

# Set up database
rails db:create
rails db:migrate

# Seed initial data
rails db:seed

# Start the development server
rails server
