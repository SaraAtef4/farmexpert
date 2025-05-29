import 'package:farmxpert/core/theme/colors.dart';
import 'package:farmxpert/core/widgets/custom_app_bar.dart';
import 'package:farmxpert/features/milk_production/screens/daily_records/form.dart';
import 'package:farmxpert/features/milk_production/screens/statistics/statistics.dart';
import 'package:farmxpert/features/milk_production/screens/daily_records/today_milk_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../core/widgets/animated_counter.dart';
import '../../../data/providers/milk_provider.dart';

class MilkProductionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Milk Production'),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Color(0xFFF5F5F5)],
          ),
        ),
        child: Padding(
          padding:  EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Padding(
                padding:  EdgeInsets.only(bottom: 20.0, top: 10.0),
                child: Text(
                  'Milk Management',
                  style: GoogleFonts.inter(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),

              // Summary Card
              _buildSummaryCard(context),

              SizedBox(height: 25),

              // Section Title
              Text(
                'Quick Actions',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),

              SizedBox(height: 15),

              // Action Cards
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio: 1.1,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  children: [
                    _buildActionCard(
                      context,
                      title: 'Daily Milk Records',
                      icon: Icons.water_drop_outlined,
                      color: Color(0xFFE3F2FD),
                      iconColor: Colors.blue,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TodayMilkScreen()),
                      ),
                    ),
                    _buildActionCard(
                      context,
                      title: 'Statistics',
                      icon: Icons.bar_chart_rounded,
                      color: Color(0xFFE8F5E9),
                      iconColor: Colors.green,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MilkStatisticsScreen()),
                      ),
                    ),
                    _buildActionCard(
                      context,
                      title: 'Add Record',
                      icon: Icons.add_circle_outline,
                      color: Color(0xFFFFF3E0),
                      iconColor: Colors.orange,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context)=> MilkEntryScreen()))
                    ),
                    _buildActionCard(
                      context,
                      title: 'Settings',
                      icon: Icons.settings_outlined,
                      color: Color(0xFFEDE7F6),
                      iconColor: Colors.purple,
                      onTap: () {
                        // Navigate to settings
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context) {
    final milkProvider = Provider.of<MilkProvider>(context);

    final todayProduction = milkProvider.getTodayTotalProduction();
    final milkPrice = milkProvider.getMilkPricePerLiter();
    final todayValue = todayProduction * milkPrice;

    final activeCows = milkProvider.getProductiveCowsCount();

    final avgPerCow = activeCows > 0 ? todayProduction / activeCows : 0;

    return AnimatedContainer(
      duration: Duration(milliseconds: 600),
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primaryColor, Color(0xFF2980b9)],
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Today\'s Summary',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              Icon(Icons.date_range, color: Colors.white70),
            ],
          ),
          SizedBox(height: 15),
          Row(
            children: [
              _buildSummaryItemAnimated(
                title: 'Total Milk',
                value: todayProduction,
                suffix: ' L',
                icon: Icons.water_drop,
              ),
              SizedBox(width: 20),
              _buildSummaryItemAnimated(
                title: 'Milk Value',
                value: todayValue,
                suffix: ' \$',
                icon: Icons.attach_money,
                isPrice: true,
              ),
            ],
          ),
          SizedBox(height: 15),
          Row(
            children: [
              _buildSummaryItemAnimated(
                title: 'Active Cows',
                value: activeCows.toDouble(),
                suffix: '',
                icon: Icons.pets,
                isInteger: true,
              ),
              SizedBox(width: 20),
              _buildSummaryItemAnimated(
                title: 'Avg/Cow',
                value: avgPerCow.toDouble(),
                suffix: ' L',
                icon: Icons.monitor_weight_outlined,
              ),
            ],
          ),
        ],
      ),
    );
  }


  Widget _buildSummaryItemAnimated({
    required String title,
    required double value,
    required String suffix,
    required IconData icon,
    bool isInteger = false,
    bool isPrice = false,
  }) {
    return Expanded(
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: Colors.white70,
                ),
              ),
              AnimatedCounter(
                value: value,
                suffix: suffix,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                isInteger: isInteger,
                isPrice: isPrice,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(
      BuildContext context, {
        required String title,
        required IconData icon,
        required Color color,
        required Color iconColor,
        required VoidCallback onTap,
      }) {
    return TweenAnimationBuilder(
        tween: Tween<double>(begin: 0.0, end: 1.0),
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        builder: (context, double value, child) {
          return Transform.scale(
            scale: value,
            child: Opacity(
              opacity: value,
              child: GestureDetector(
                onTap: () {

                  HapticFeedback.lightImpact();
                  onTap();
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          icon,
                          color: iconColor,
                          size: 30,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        title,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
    );
  }
}





