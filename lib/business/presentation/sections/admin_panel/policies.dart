import 'package:cat_tourism_hub/business/providers/partner_acct_provider.dart';
import 'package:cat_tourism_hub/core/constants/strings/strings.dart';
import 'package:cat_tourism_hub/core/auth/auth_provider.dart';
import 'package:cat_tourism_hub/core/utils/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Policies extends StatefulWidget {
  const Policies({super.key});

  @override
  State<Policies> createState() => _PoliciesState();
}

class _PoliciesState extends State<Policies> {
  final TextEditingController _policyController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late String _uid;
  bool _isEditMode = false;
  late PartnerAcctProvider estProvider;

  @override
  void initState() {
    super.initState();
    final acctProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);
    _uid = acctProvider.user!.uid;
    estProvider = Provider.of<PartnerAcctProvider>(context, listen: false);
    _policyController.text = estProvider.establishment!.policies ?? '';
  }

  @override
  void dispose() {
    _policyController.dispose();
    super.dispose();
  }

  Future _savePolicy() async {
    String result = '';
    try {
      result = await estProvider.savePolicy(_policyController.text, _uid);
    } catch (e) {
      result = e.toString();
    } finally {
      SnackbarHelper.showSnackBar(result);
      setState(() {
        _isEditMode = false;
      });
    }
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Text(
            AppStrings.policies,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ),
        const SizedBox(width: 10),
        Card(
          child: TextButton.icon(
            icon: Icon(_isEditMode ? Icons.save_outlined : Icons.edit_outlined),
            onPressed: () => _isEditMode
                ? _savePolicy()
                : setState(() {
                    _isEditMode = true;
                  }),
            label: Text(_isEditMode ? AppStrings.save : AppStrings.edit),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PartnerAcctProvider>(
      builder: (context, value, widget) => SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              Expanded(
                child: _isEditMode
                    ? TextFormField(
                        controller: _policyController,
                        style: Theme.of(context).textTheme.bodySmall,
                        expands: true,
                        maxLines: null,
                        textAlignVertical: TextAlignVertical.top,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter your policy here...',
                          alignLabelWithHint: true,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          contentPadding: EdgeInsets.only(
                              top: 16.0, left: 16.0, right: 16.0),
                        ),
                        onChanged: (value) {
                          setState(() {});
                        },
                      )
                    : SingleChildScrollView(
                        child: SizedBox(
                          height: MediaQuery.sizeOf(context).height,
                          width: MediaQuery.sizeOf(context).width,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(value.establishment!.policies ?? ''),
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
