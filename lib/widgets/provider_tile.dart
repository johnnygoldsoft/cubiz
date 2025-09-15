import 'package:flutter/material.dart';
import '../models/provider_model.dart';

class ProviderTile extends StatelessWidget {
  final ProviderModel providerModel;
  final VoidCallback? onTap;
  const ProviderTile({required this.providerModel, this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(providerModel.name),
      subtitle: Text(providerModel.address),
      trailing: Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
