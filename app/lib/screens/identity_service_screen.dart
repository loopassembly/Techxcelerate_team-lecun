import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class IdentityServiceScreen extends StatefulWidget {
  const IdentityServiceScreen({super.key});

  @override
  State<IdentityServiceScreen> createState() => _IdentityServiceScreenState();
}

class _IdentityServiceScreenState extends State<IdentityServiceScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _services = [];
  List<Map<String, dynamic>> _filteredServices = [];

  @override
  void initState() {
    super.initState();
    _services = [
      {
        'icon': Icons.flight,
        'title': 'Travel',
        'subtitle': 'Airline & Railway',
        'color': const Color(0xFF6881FF),
      },
      {
        'icon': Icons.account_balance,
        'title': 'Banking',
        'subtitle': 'Financial Services',
        'color': const Color(0xFF6881FF),
      },
      {
        'icon': Icons.account_balance_wallet,
        'title': 'Government',
        'subtitle': 'Official Services',
        'color': const Color(0xFF6881FF),
      },
      {
        'icon': Icons.local_hospital,
        'title': 'Healthcare',
        'subtitle': 'Medical Services',
        'color': const Color(0xFF6881FF),
      },
    ];
    _filteredServices = List.from(_services);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterServices(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredServices = List.from(_services);
      });
    } else {
      setState(() {
        _filteredServices = _services
            .where((service) =>
                service['title'].toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  Widget _buildTopLines() {
    return Row(
      children: [
        Expanded(
          flex: 68,
          child: Container(
            height: 5,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 18,
          child: Container(
            height: 5,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 8,
          child: Container(
            height: 5,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.06),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenSize.height * 0.04),
              Text(
                'Identity Service',
                style: TextStyle(
                  fontSize: screenSize.width * 0.055,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
              SizedBox(height: screenSize.height * 0.015),
              _buildTopLines(),
              SizedBox(height: screenSize.height * 0.03),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: _filterServices,
                  decoration: InputDecoration(
                    hintText: 'Search',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: screenSize.width * 0.04,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.grey.shade500,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),
              SizedBox(height: screenSize.height * 0.03),
              Expanded(
                child: ListView.builder(
                  itemCount: _filteredServices.length,
                  itemBuilder: (context, index) {
                    final service = _filteredServices[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.grey.shade200),
                      ),
                      child: ListTile(
                        onTap: () => context.push('/authentication'),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        leading: CircleAvatar(
                          backgroundColor: service['color'].withOpacity(0.1),
                          radius: 20,
                          child: Icon(
                            service['icon'],
                            color: service['color'],
                            size: 24,
                          ),
                        ),
                        title: Text(
                          service['title'],
                          style: TextStyle(
                            fontSize: screenSize.width * 0.04,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1A1A1A),
                          ),
                        ),
                        subtitle: Text(
                          service['subtitle'],
                          style: TextStyle(
                            fontSize: screenSize.width * 0.035,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.grey.shade400,
                          size: 16,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
