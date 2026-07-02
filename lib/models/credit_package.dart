class CreditPackage {
  const CreditPackage({
    required this.id,
    required this.title,
    required this.credits,
    required this.priceLabel,
    this.isPopular = false,
    this.description,
  });

  final String id;
  final String title;
  final int credits;
  final String priceLabel;
  final bool isPopular;
  final String? description;
}

const creditPackages = [
  CreditPackage(
    id: 'starter',
    title: 'Starter',
    credits: 3,
    priceLabel: '\$2.99',
    description: 'Perfect for a few more insights',
  ),
  CreditPackage(
    id: 'popular',
    title: 'Popular',
    credits: 10,
    priceLabel: '\$6.99',
    isPopular: true,
    description: 'Best value for regular explorers',
  ),
  CreditPackage(
    id: 'unlimited',
    title: 'Unlimited',
    credits: 999,
    priceLabel: '\$14.99',
    description: 'Explore without limits',
  ),
];

const initialCredits = 2;
const testCreditCost = 1;
