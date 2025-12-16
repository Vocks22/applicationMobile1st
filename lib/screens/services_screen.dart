import 'package:flutter/material.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nos Services',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Accompagnement personnalise pour integrer l\'IA dans votre entreprise',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 32),
            _ServiceCard(
              icon: Icons.search,
              title: 'Audit IA',
              description: 'Evaluation complete de la maturite IA de votre entreprise et cartographie des processus metiers automatisables.',
              color: Colors.blue,
              features: const [
                'Analyse des processus existants',
                'Identification des opportunites',
                'Rapport detaille et recommandations',
              ],
            ),
            const SizedBox(height: 20),
            _ServiceCard(
              icon: Icons.school,
              title: 'Formation',
              description: 'Programmes de formation sur-mesure pour accompagner vos equipes dans l\'adoption de l\'IA.',
              color: Colors.green,
              features: const [
                'Formations adaptees a chaque niveau',
                'Ateliers pratiques',
                'Support continu',
              ],
            ),
            const SizedBox(height: 20),
            _ServiceCard(
              icon: Icons.auto_awesome,
              title: 'Automatisation',
              description: 'Solutions IA cle en main pour automatiser vos processus et gagner en efficacite.',
              color: Colors.orange,
              features: const [
                'Chatbots et assistants virtuels',
                'Automatisation documentaire',
                'Integration API',
              ],
            ),
            const SizedBox(height: 20),
            _ServiceCard(
              icon: Icons.support_agent,
              title: 'Accompagnement',
              description: 'Support technique et operationnel continu pour garantir le succes de vos projets IA.',
              color: Colors.purple,
              features: const [
                'Suivi de projet personnalise',
                'Maintenance et evolution',
                'Support prioritaire',
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final List<String> features;

  const _ServiceCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.features,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  description,
                  style: theme.textTheme.bodyLarge,
                ),
                const SizedBox(height: 16),
                ...features.map((feature) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, color: color, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          feature,
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
