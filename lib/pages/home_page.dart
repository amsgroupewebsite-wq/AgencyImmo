// ============================================================================
//  IMMO Agency – Écran d'accueil
//  Reconstruction fidèle de la maquette en Flutter (Material 3).
//
//  ⚠️ Images : remplace les chemins 'assets/images/...' par tes propres
//     assets et déclare-les dans pubspec.yaml. Un fallback dégradé s'affiche
//     automatiquement si l'asset est introuvable (pour pouvoir lancer le code
//     tel quel sans assets).
// ============================================================================

import 'package:flutter/material.dart';

void main() => runApp(const ImmoApp());

class ImmoApp extends StatelessWidget {
  const ImmoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'IMMO Agency',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.navy),
        fontFamily: 'Poppins', // facultatif – retire si non déclaré
      ),
      home: const HomePage(),
    );
  }
}

// ---------------------------------------------------------------------------
//  Palette centralisée
// ---------------------------------------------------------------------------
class AppColors {
  static const navy = Color(0xFF14375A);
  static const background = Color(0xFFF8F8FC);
  static const chip = Color(0xFFF1F1F6);
  static const red = Color(0xFFE63946);
  static const star = Color(0xFFFCA311);
  static const grey = Color(0xFF8A94A6);
}

// ---------------------------------------------------------------------------
//  Modèle de données
// ---------------------------------------------------------------------------
class Property {
  final String title;
  final String location;
  final String type;
  final double rating;
  final int price;
  final String image;
  final bool favorite;

  const Property({
    required this.title,
    required this.location,
    required this.type,
    required this.rating,
    required this.price,
    required this.image,
    this.favorite = false,
  });
}

// Données d'exemple (à remplacer par ton API / repository)
const _featured = <Property>[
  Property(
    title: 'Sky Dandelions\nApartment',
    location: 'Hydra, Alger',
    type: 'Apartment',
    rating: 4.9,
    price: 290,
    image: 'assets/images/apartment.jpg',
    favorite: true,
  ),
  Property(
    title: 'Villa Bord de Mer',
    location: 'Moretti, Alger',
    type: 'Villa',
    rating: 4.8,
    price: 540,
    image: 'assets/images/villa.jpg',
    favorite: true,
  ),
];

const _nearby = <Property>[
  Property(
    title: 'Cité El Hayat',
    location: 'Bab Ezzouar, Alger',
    type: 'Apartment',
    rating: 4.9,
    price: 220,
    image: 'assets/images/p1.jpg',
    favorite: true,
  ),
  Property(
    title: 'Mill Sper House',
    location: 'Hydra, Alger',
    type: 'House',
    rating: 4.8,
    price: 271,
    image: 'assets/images/p2.jpg',
  ),
  Property(
    title: 'Bungalow House',
    location: 'El Eulma, Sétif',
    type: 'House',
    rating: 4.7,
    price: 235,
    image: 'assets/images/p3.jpg',
  ),
  Property(
    title: 'Sky Dandelions\nApartment',
    location: 'St Hubert, Oran',
    type: 'Apartment',
    rating: 4.9,
    price: 290,
    image: 'assets/images/p4.jpg',
  ),
];

const _categories = ['Tout', 'Maison', 'Apartments', 'Chambre'];
const _locations = ['Hydra', 'El Biar', 'Beni Messous'];

// ---------------------------------------------------------------------------
//  Page d'accueil
// ---------------------------------------------------------------------------
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedCategory = 0;
  int _navIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _BottomNavBar(
        currentIndex: _navIndex,
        onTap: (i) => setState(() => _navIndex = i),
      ),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 0, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(right: 20),
                child: _Header(),
              ),
              const SizedBox(height: 22),

              // Salutation
              const Padding(
                padding: EdgeInsets.only(right: 20),
                child: _Greeting(name: 'Amine'),
              ),
              const SizedBox(height: 18),

              // Barre de recherche
              const Padding(
                padding: EdgeInsets.only(right: 20),
                child: _SearchBar(),
              ),
              const SizedBox(height: 22),

              // Catégories
              _CategoryList(
                selected: _selectedCategory,
                onSelect: (i) => setState(() => _selectedCategory = i),
              ),
              const SizedBox(height: 22),

              // Bannière promo
              const _PromoCarousel(),
              const SizedBox(height: 26),

              // Propriétés présentées
              const Padding(
                padding: EdgeInsets.only(right: 20),
                child: _SectionHeader(
                  title: 'Propriétés Présentées',
                  action: 'Voir Tous',
                ),
              ),
              const SizedBox(height: 16),
              _FeaturedList(items: _featured),
              const SizedBox(height: 26),

              // Top endroits
              const Padding(
                padding: EdgeInsets.only(right: 20),
                child: _SectionHeader(title: 'Top Endroits', action: 'explore'),
              ),
              const SizedBox(height: 16),
              const _LocationList(locations: _locations),
              const SizedBox(height: 26),

              // À proximité
              const Padding(
                padding: EdgeInsets.only(right: 20),
                child: Text(
                  'Explorer les propriétés à proximité',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                    color: AppColors.navy,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: _NearbyGrid(items: _nearby),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
//  En-tête : logo + localisation + notifications + avatar
// ---------------------------------------------------------------------------
class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // Logo
            Image.asset(
              'assets/images/logo.png',
              height: 28,
              errorBuilder: (_, __, ___) => Row(
                children: const [
                  Icon(Icons.real_estate_agent, color: AppColors.navy),
                  SizedBox(width: 6),
                  Text(
                    'IMMO',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: AppColors.navy,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            // Notifications
            _CircleButton(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(Icons.notifications_none,
                      color: AppColors.navy, size: 22),
                  Positioned(
                    right: -1,
                    top: -1,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            // Avatar
            const _CircleImage(
              asset: 'assets/images/avatar.jpg',
              radius: 20,
              fallbackIcon: Icons.person,
            ),
          ],
        ),
        const SizedBox(height: 14),
        // Sélecteur de localisation
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE3E3EC)),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.location_on, color: AppColors.navy, size: 18),
              SizedBox(width: 6),
              Text(
                'Hydra, Alger',
                style: TextStyle(
                  color: AppColors.navy,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 4),
              Icon(Icons.keyboard_arrow_down, color: AppColors.navy, size: 20),
            ],
          ),
        ),
      ],
    );
  }
}

class _CircleButton extends StatelessWidget {
  final Widget child;
  const _CircleButton({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFE3E3EC)),
      ),
      child: child,
    );
  }
}

// ---------------------------------------------------------------------------
//  Salutation
// ---------------------------------------------------------------------------
class _Greeting extends StatelessWidget {
  final String name;
  const _Greeting({required this.name});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: const TextStyle(
              fontSize: 26,
              color: AppColors.navy,
              fontWeight: FontWeight.w500,
            ),
            children: [
              const TextSpan(text: 'Bonjour, '),
              TextSpan(
                text: '$name!',
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ),
        const Text(
          'Commençons à explorer',
          style: TextStyle(
            fontSize: 26,
            color: AppColors.navy,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
//  Barre de recherche
// ---------------------------------------------------------------------------
class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.chip,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: AppColors.grey),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              decoration: const InputDecoration(
                isCollapsed: true,
                border: InputBorder.none,
                hintText: 'Rechercher une maison etc.',
                hintStyle: TextStyle(color: AppColors.grey),
              ),
              style: const TextStyle(color: AppColors.navy),
            ),
          ),
          Container(width: 1, height: 22, color: const Color(0xFFD8D8E2)),
          const SizedBox(width: 12),
          const Icon(Icons.mic_none, color: AppColors.grey),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
//  Liste de catégories
// ---------------------------------------------------------------------------
class _CategoryList extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onSelect;
  const _CategoryList({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(right: 20),
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, i) {
          final active = i == selected;
          return GestureDetector(
            onTap: () => onSelect(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 22),
              decoration: BoxDecoration(
                color: active ? AppColors.navy : AppColors.chip,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                _categories[i],
                style: TextStyle(
                  color: active ? Colors.white : AppColors.navy,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
//  Carrousel promo
// ---------------------------------------------------------------------------
class _PromoCarousel extends StatelessWidget {
  const _PromoCarousel();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 170,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 20, right: 20),
        itemCount: 3,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (_, __) => const _PromoCard(),
      ),
    );
  }
}

class _PromoCard extends StatelessWidget {
  const _PromoCard();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: SizedBox(
        width: 320,
        child: Stack(
          fit: StackFit.expand,
          children: [
            _PropertyImage(asset: 'assets/images/promo.jpg'),
            // Voile sombre pour lisibilité
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    AppColors.navy.withOpacity(0.85),
                    AppColors.navy.withOpacity(0.15),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Sold d'été",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'All discount up to 60%',
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                    ],
                  ),
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: AppColors.navy,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.arrow_forward, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
//  En-tête de section réutilisable
// ---------------------------------------------------------------------------
class _SectionHeader extends StatelessWidget {
  final String title;
  final String action;
  const _SectionHeader({required this.title, required this.action});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w700,
            color: AppColors.navy,
          ),
        ),
        Text(
          action,
          style: const TextStyle(
            color: AppColors.navy,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
//  Propriétés présentées (cartes horizontales)
// ---------------------------------------------------------------------------
class _FeaturedList extends StatelessWidget {
  final List<Property> items;
  const _FeaturedList({required this.items});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 20, right: 20),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (_, i) => _FeaturedCard(property: items[i]),
      ),
    );
  }
}

class _FeaturedCard extends StatelessWidget {
  final Property property;
  const _FeaturedCard({required this.property});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      decoration: BoxDecoration(
        color: AppColors.chip,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          // Image + favori + badge type
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: SizedBox(
              width: 130,
              height: 150,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  _PropertyImage(asset: property.image),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: _FavoriteBadge(filled: property.favorite),
                  ),
                  Positioned(
                    bottom: 10,
                    left: 10,
                    child: _TypeTag(label: property.type),
                  ),
                ],
              ),
            ),
          ),
          // Détails
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    property.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.navy,
                      fontSize: 15,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _RatingRow(rating: property.rating),
                  const SizedBox(height: 4),
                  _LocationRow(location: property.location),
                  const SizedBox(height: 10),
                  _PriceText(price: property.price),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
//  Top endroits
// ---------------------------------------------------------------------------
class _LocationList extends StatelessWidget {
  final List<String> locations;
  const _LocationList({required this.locations});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 20, right: 20),
        itemCount: locations.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, i) => Container(
          padding: const EdgeInsets.fromLTRB(8, 8, 20, 8),
          decoration: BoxDecoration(
            color: AppColors.chip,
            borderRadius: BorderRadius.circular(40),
          ),
          child: Row(
            children: [
              _CircleImage(
                asset: 'assets/images/loc${i + 1}.jpg',
                radius: 24,
                fallbackIcon: Icons.location_city,
              ),
              const SizedBox(width: 12),
              Text(
                locations[i],
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.navy,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
//  Grille « à proximité »
// ---------------------------------------------------------------------------
class _NearbyGrid extends StatelessWidget {
  final List<Property> items;
  const _NearbyGrid({required this.items});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.74,
      ),
      itemBuilder: (_, i) => _GridCard(property: items[i]),
    );
  }
}

class _GridCard extends StatelessWidget {
  final Property property;
  const _GridCard({required this.property});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.navy.withOpacity(.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image + favori + prix
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            child: SizedBox(
              height: 130,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  _PropertyImage(asset: property.image),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: _FavoriteBadge(filled: property.favorite),
                  ),
                  Positioned(
                    bottom: 10,
                    left: 10,
                    child: Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.navy,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: _PriceText(price: property.price, light: true),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  property.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.navy,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star, color: AppColors.star, size: 15),
                    const SizedBox(width: 3),
                    Text(
                      property.rating.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.navy,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.location_on,
                        color: AppColors.red, size: 14),
                    const SizedBox(width: 2),
                    Expanded(
                      child: Text(
                        property.location,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.grey,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
//  Petits widgets partagés
// ---------------------------------------------------------------------------
class _FavoriteBadge extends StatelessWidget {
  final bool filled;
  const _FavoriteBadge({required this.filled});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: filled ? AppColors.red : Colors.white,
        shape: BoxShape.circle,
      ),
      child: Icon(
        filled ? Icons.favorite : Icons.favorite_border,
        size: 16,
        color: filled ? Colors.white : AppColors.red,
      ),
    );
  }
}

class _TypeTag extends StatelessWidget {
  final String label;
  const _TypeTag({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.navy,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _RatingRow extends StatelessWidget {
  final double rating;
  const _RatingRow({required this.rating});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.star, color: AppColors.star, size: 16),
        const SizedBox(width: 4),
        Text(
          rating.toString(),
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.navy,
          ),
        ),
      ],
    );
  }
}

class _LocationRow extends StatelessWidget {
  final String location;
  const _LocationRow({required this.location});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.location_on, color: AppColors.red, size: 15),
        const SizedBox(width: 3),
        Expanded(
          child: Text(
            location,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: AppColors.grey, fontSize: 12),
          ),
        ),
      ],
    );
  }
}

class _PriceText extends StatelessWidget {
  final int price;
  final bool light;
  const _PriceText({required this.price, this.light = false});

  @override
  Widget build(BuildContext context) {
    final main = light ? Colors.white : AppColors.navy;
    final sub = light ? Colors.white70 : AppColors.grey;
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '\$ $price',
            style: TextStyle(
              color: main,
              fontWeight: FontWeight.w800,
              fontSize: light ? 14 : 18,
            ),
          ),
          TextSpan(
            text: '/month',
            style: TextStyle(color: sub, fontSize: light ? 10 : 12),
          ),
        ],
      ),
    );
  }
}

/// Image avec fallback dégradé si l'asset est introuvable.
class _PropertyImage extends StatelessWidget {
  final String asset;
  const _PropertyImage({required this.asset});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      asset,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => const DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFB8C4D6), AppColors.navy],
          ),
        ),
        child: Center(
          child: Icon(Icons.home_work_outlined,
              color: Colors.white54, size: 36),
        ),
      ),
    );
  }
}

/// Image circulaire avec fallback si l'asset est introuvable.
class _CircleImage extends StatelessWidget {
  final String asset;
  final double radius;
  final IconData fallbackIcon;
  const _CircleImage({
    required this.asset,
    required this.radius,
    required this.fallbackIcon,
  });

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: SizedBox(
        width: radius * 2,
        height: radius * 2,
        child: Image.asset(
          asset,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            color: AppColors.chip,
            alignment: Alignment.center,
            child: Icon(fallbackIcon, color: AppColors.grey, size: radius),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
//  Barre de navigation flottante
// ---------------------------------------------------------------------------
class _BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  const _BottomNavBar({required this.currentIndex, required this.onTap});

  static const _icons = [
    Icons.home_filled,
    Icons.menu,
    Icons.map_outlined,
    Icons.favorite_border,
    Icons.person_outline,
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 12),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(34),
          boxShadow: [
            BoxShadow(
              color: AppColors.navy.withOpacity(.12),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(_icons.length, (i) {
            final active = i == currentIndex;
            return GestureDetector(
              onTap: () => onTap(i),
              behavior: HitTestBehavior.opaque,
              child: Container(
                width: active ? 52 : 44,
                height: 52,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: active ? AppColors.navy : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Icon(
                      _icons[i],
                      color: active ? Colors.white : AppColors.grey,
                    ),
                    // Badge sur le favori
                    if (i == 3)
                      Positioned(
                        right: -6,
                        top: -6,
                        child: Container(
                          width: 16,
                          height: 16,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            color: AppColors.red,
                            shape: BoxShape.circle,
                          ),
                          child: const Text(
                            '1',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}