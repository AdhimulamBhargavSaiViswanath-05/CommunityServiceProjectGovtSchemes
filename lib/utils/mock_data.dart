import 'package:myscheme_app/models/scheme.dart';

final List<Scheme> mockSchemes = [
  Scheme(
    id: '1',
    slug: 'pm-kisan',
    title: 'Pradhan Mantri Kisan Samman Nidhi (PM-KISAN)',
    shortTitle: 'PM-KISAN',
    description:
        'A government scheme with the objective to supplement the financial needs of all landholding farmers\' families in procuring various inputs to ensure proper crop health and appropriate yields.',
    detailedDescription:
        'PM-KISAN provides income support to farmer families across the country to supplement their financial needs for procuring various inputs related to agriculture and allied activities as also domestic needs.',
    benefits:
        '**Financial Assistance:** ₹6,000 per year in three equal installments of ₹2,000 each.\n\n**Direct Transfer:** Money transferred directly to farmers\' bank accounts.',
    eligibility:
        '- All landholding farmer families\n- Must have cultivable land\n- Valid Aadhaar card linked to bank account',
    exclusions: 'Institutional landholders are not eligible.',
    ministry: 'Ministry of Agriculture and Farmers Welfare',
    applicationProcess:
        '1. Visit the official PM-KISAN portal\n2. Click on "New Farmer Registration"\n3. Fill in required details\n4. Submit Aadhaar and land ownership documents\n5. Complete the registration',
    documents: ['Aadhaar Card', 'Landholding papers', 'Bank account details'],
    faqs: [
      FAQ(
        question: 'Who can apply for PM-KISAN?',
        answer: 'All landholding farmer families can apply.',
      ),
      FAQ(
        question: 'How much money is provided?',
        answer: '₹6,000 per year in three installments.',
      ),
    ],
    references: [
      Reference(
        title: 'Official Website',
        url: 'https://pmkisan.gov.in/',
      ),
    ],
    category: 'Agriculture',
    deadline: 'Ongoing',
    link: 'https://pmkisan.gov.in/',
  ),
  Scheme(
    id: '2',
    slug: 'pmjdy',
    title: 'Pradhan Mantri Jan Dhan Yojana (PMJDY)',
    shortTitle: 'PMJDY',
    description:
        'National Mission for Financial Inclusion to ensure access to financial services, namely, Banking/ Savings & Deposit Accounts, Remittance, Credit, Insurance, Pension in an affordable manner.',
    detailedDescription:
        'PMJDY is a comprehensive financial inclusion scheme ensuring access to various financial services for all citizens.',
    benefits:
        '**Zero Balance Account:** No minimum balance requirement\n**RuPay Debit Card:** Free debit card with inbuilt insurance\n**Insurance Coverage:** ₹2 lakh accidental insurance',
    eligibility:
        '- Any individual above 10 years of age\n- Does not have a bank account\n- Valid identity proof',
    exclusions: 'Individuals who already have bank accounts.',
    ministry: 'Ministry of Finance',
    applicationProcess:
        '1. Visit nearest bank branch\n2. Fill PMJDY account opening form\n3. Submit required documents\n4. Receive account details and RuPay card',
    documents: [
      'Aadhaar Card',
      'PAN Card (if available)',
      'Passport size photos',
    ],
    faqs: [
      FAQ(
        question: 'Is there any minimum balance requirement?',
        answer: 'No, PMJDY accounts have zero balance requirement.',
      ),
    ],
    references: [
      Reference(
        title: 'Official Website',
        url: 'https://www.pmjdy.gov.in/',
      ),
    ],
    category: 'Financial Inclusion',
    deadline: 'Ongoing',
    link: 'https://www.pmjdy.gov.in/',
  ),
  Scheme(
    id: '3',
    slug: 'apy',
    title: 'Atal Pension Yojana (APY)',
    shortTitle: 'APY',
    description:
        'A pension scheme for citizens of India focused on the unorganized sector workers.',
    detailedDescription:
        'APY provides guaranteed minimum pension of ₹1,000 to ₹5,000 per month at the age of 60 years depending on contributions.',
    benefits:
        '**Guaranteed Pension:** ₹1,000 to ₹5,000 monthly pension\n**Government Co-contribution:** 50% of contribution or ₹1,000 per annum (whichever is lower)\n**Spouse Pension:** Same pension amount to spouse after subscriber\'s death',
    eligibility:
        '- Between 18 and 40 years of age\n- Must have a savings bank account\n- Valid Aadhaar card',
    exclusions: 'Individuals covered under statutory social security schemes.',
    ministry: 'Ministry of Finance',
    applicationProcess:
        '1. Visit bank with savings account\n2. Fill APY registration form\n3. Provide Aadhaar and mobile number\n4. Choose pension amount\n5. Start contributing monthly',
    documents: ['Aadhaar Card', 'Bank account details', 'Mobile number'],
    faqs: [
      FAQ(
        question: 'What is the minimum pension amount?',
        answer: 'Minimum pension is ₹1,000 per month.',
      ),
    ],
    references: [
      Reference(
        title: 'Official Portal',
        url: 'https://npscra.nsdl.co.in/scheme-details/atal-pension-yojana.php',
      ),
    ],
    category: 'Pension',
    deadline: 'Ongoing',
    link: 'https://npscra.nsdl.co.in/scheme-details/atal-pension-yojana.php',
  ),
  Scheme(
    id: '4',
    slug: 'pmsby',
    title: 'Pradhan Mantri Suraksha Bima Yojana (PMSBY)',
    shortTitle: 'PMSBY',
    description:
        'An accident insurance scheme offering accidental death and disability cover for death or disability on account of an accident.',
    detailedDescription:
        'PMSBY provides accident insurance coverage of ₹2 lakh at a premium of just ₹12 per year.',
    benefits:
        '**Accidental Death:** ₹2 lakh cover\n**Permanent Total Disability:** ₹2 lakh cover\n**Permanent Partial Disability:** ₹1 lakh cover',
    eligibility:
        '- Age 18-70 years with a bank account\n- Valid Aadhaar card\n- Annual renewal required',
    exclusions: 'Death or disability due to pre-existing conditions.',
    ministry: 'Ministry of Finance',
    applicationProcess:
        '1. Visit bank branch\n2. Fill PMSBY enrollment form\n3. Provide consent for auto-debit\n4. Pay ₹12 annual premium\n5. Receive insurance certificate',
    documents: ['Aadhaar Card', 'Bank account for auto-debit'],
    faqs: [
      FAQ(
        question: 'What is the premium amount?',
        answer: 'Only ₹12 per year.',
      ),
    ],
    references: [
      Reference(
        title: 'Official Website',
        url:
            'https://financialservices.gov.in/insurance-divisions/Pradhan-Mantri-Suraksha-Bima-Yojana(PMSBY)',
      ),
    ],
    category: 'Insurance',
    deadline: 'Annual Renewal',
    link:
        'https://financialservices.gov.in/insurance-divisions/Pradhan-Mantri-Suraksha-Bima-Yojana(PMSBY)',
  ),
];
