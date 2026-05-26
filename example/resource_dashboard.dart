import 'package:flint_ui/flint_ui.dart';

void main() {
  createFlintApp(
    '#app',
    pages: {'Plans': (props) => PlansResourceExample(props)},
  );
}

class PlansResourceExample extends FlintComponent {
  PlansResourceExample(this.props) {
    plans = ResourceController<List<FlintModelRecord>>(
      initialData: _initialPlans(props),
      loader: () => FlintModelApi<FlintModelRecord>.records('/plans').list(),
    );
  }

  Map<String, dynamic> props;
  late final ResourceController<List<FlintModelRecord>> plans;

  final form = useForm({'name': '', 'price': ''});

  @override
  void didMount() {
    plans.refresh(silent: true);
  }

  @override
  void updateFrom(covariant PlansResourceExample next) {
    props = next.props;
  }

  @override
  void willUnmount() {
    plans.dispose();
  }

  @override
  FlintNode build() {
    return PageShell(
      header: PageHeader(
        title: 'Plans Resource Example',
        description:
            'Server props hydrate the first render. ResourceController refreshes the same data from FlintDart.',
        actions: Button(
          child: 'Refresh',
          onPressed: (_) => plans.refresh(silent: true),
        ),
      ),
      child: ResponsiveGrid(
        minItemWidth: 360,
        children: [
          Panel(
            title: 'Plans',
            description: 'Loaded from props, then refreshed from GET /plans.',
            child: ResourceView<List<FlintModelRecord>>(plans, (snapshot) {
              final rows = snapshot.data ?? const <FlintModelRecord>[];

              if (snapshot.isLoading && rows.isEmpty) {
                return DataTable(columns: _columns, loading: true);
              }

              if (snapshot.isError && rows.isEmpty) {
                return EmptyState(
                  title: 'Could not load plans',
                  message: snapshot.error.toString(),
                );
              }

              return Column(
                children: [
                  if (snapshot.isError)
                    Alert(
                      title: 'Showing cached data',
                      message: snapshot.error.toString(),
                      tone: Tone.warning,
                    ),
                  DataTable(
                    columns: _columns,
                    rows: [
                      for (final plan in rows)
                        TableRowData(
                          key: plan.id?.toString(),
                          cells: {
                            'name': plan.string('name') ?? 'Plan',
                            'disk': '${plan.integer('disk_limit') ?? 0} GB',
                            'price': '\$${plan.string('price') ?? '0'}',
                          },
                          actions: Button(
                            child: 'Remove',
                            onPressed: (_) => _removePlan(plan),
                          ),
                        ),
                    ],
                  ),
                ],
              );
            }),
          ),
          Panel(
            title: 'Local mutation',
            description:
                'FormController keeps input state. ResourceController mutates the visible list.',
            child: Form(
              onSubmit: (_) => _addPlan(),
              children: [
                TextField(
                  label: 'Plan name',
                  name: 'name',
                  controller: form.controller('name'),
                  placeholder: 'Business',
                  required: true,
                ),
                TextField(
                  label: 'Price',
                  name: 'price',
                  controller: form.controller('price'),
                  placeholder: '29',
                  required: true,
                ),
                Button(child: 'Add locally', props: const {'type': 'submit'}),
                Text.small(
                  'This does not POST to the server. It demonstrates client-side resource state.',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static const _columns = [
    TableColumn(key: 'name', label: 'Plan'),
    TableColumn(key: 'disk', label: 'Disk'),
    TableColumn(key: 'price', label: 'Price'),
  ];

  void _addPlan() {
    final name = form.string('name').trim();
    final price = form.string('price').trim();

    if (name.isEmpty || price.isEmpty) return;

    plans.mutate((current) {
      return [
        ...current ?? const <FlintModelRecord>[],
        FlintModelRecord({
          'id': 'local-${DateTime.now().microsecondsSinceEpoch}',
          'name': name,
          'disk_limit': 10,
          'price': price,
        }),
      ];
    });

    form.reset();
    setState(() {});
  }

  void _removePlan(FlintModelRecord plan) {
    plans.mutate((current) {
      return [
        for (final item in current ?? const <FlintModelRecord>[])
          if (item.id != plan.id) item,
      ];
    });
  }

  List<FlintModelRecord> _initialPlans(Map<String, dynamic> props) {
    final raw = props['plans'];
    if (raw is List && raw.isNotEmpty) {
      return raw.whereType<Map>().map((item) {
        return FlintModelRecord(
          item.map((key, value) => MapEntry(key.toString(), value)),
        );
      }).toList();
    }

    return const [
      FlintModelRecord({
        'id': 'starter',
        'name': 'Starter',
        'disk_limit': 5,
        'price': 9,
      }),
      FlintModelRecord({
        'id': 'business',
        'name': 'Business',
        'disk_limit': 25,
        'price': 29,
      }),
    ];
  }
}
