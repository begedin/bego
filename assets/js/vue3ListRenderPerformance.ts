const d3 = (window as any).d3

const dataSimple = [
  {
    category: "List",
    fullRender: 260,
    insertOperation: 47,
    insertRender: 20,
    updateOperation: 17.5,
    updateRender: 12.5,
    removeOperation: 37.5,
    removeRender: 8.5
  },
  {
    category: "List with item components",
    fullRender: 450,
    insertOperation: 47,
    insertRender: 42.5,
    updateOperation: 17.5,
    updateRender: 0,
    removeOperation: 37.5,
    removeRender: 35
  },
  {
    category: "Virtual list",
    fullRender: 5,
    insertOperation: 47,
    insertRender: 0.35,
    updateOperation: 17.5,
    updateRender: 0,
    removeOperation: 37.5,
    removeRender: 0.4
  },
  {
    category: "Virtual list with item components",
    fullRender: 7,
    insertOperation: 47,
    insertRender: 0.8,
    updateOperation: 17.5,
    updateRender: 0,
    removeOperation: 37.5,
    removeRender: 1
  },
];

const dataComputed = [
  {
    category: "List",
    fullRender: 295,
    insertOperation: 18,
    insertRender: 8,
    updateOperation: 0.05,
    updateRender: 12.5,
    removeOperation: 16,
    removeRender: 8
  },
  {
    category: "List with item components",
    fullRender: 380,
    insertOperation: 28,
    insertRender: 40,
    updateOperation: 0.04,
    updateRender: 0,
    removeOperation: 28,
    removeRender: 38
  },
  {
    category: "Virtual list",
    fullRender: 6,
    insertOperation: 16,
    insertRender: 0.4,
    updateOperation: 0.05,
    updateRender: 0,
    removeOperation: 12,
    removeRender: 0.27
  },
  {
    category: "Virtual list with item components",
    fullRender: 8,
    insertOperation: 28,
    insertRender: 12,
    updateOperation: 0.05,
    updateRender: 0,
    removeOperation: 18,
    removeRender: 12
  },
];

const dataRef = [
  {
    category: "List",
    fullRender: 295,
    insertOperation: 18,
    insertRender: 8,
    updateOperation: 0.05,
    updateRender: 12.5,
    removeOperation: 16,
    removeRender: 8
  },
  {
    category: "List with item components",
    fullRender: 380,
    insertOperation: 28,
    insertRender: 40,
    updateOperation: 0.04,
    updateRender: 0,
    removeOperation: 28,
    removeRender: 38
  },
  {
    category: "Virtual list",
    fullRender: 6,
    insertOperation: 16,
    insertRender: 0.4,
    updateOperation: 0.05,
    updateRender: 0,
    removeOperation: 12,
    removeRender: 0.27
  },
  {
    category: "Virtual list with item components",
    fullRender: 8,
    insertOperation: 28,
    insertRender: 12,
    updateOperation: 0.05,
    updateRender: 0,
    removeOperation: 18,
    removeRender: 12
  },
];


const setupChart = (container, data) => {
  const w = 500;
  const h = 500;
  const padding = 40;

  const svg = d3.select(container).append('svg').attr('width', w).attr('height', h);

  const datasets = [
    d3.stack().keys(['fullRender'])(data),
    d3.stack().keys(['insertOperation', 'insertRender'])(data),
    d3.stack().keys(['updateOperation', 'updateRender'])(data),
    d3.stack().keys(['removeOperation', 'removeRender'])(data)
  ];

  const numGroups = datasets.length;

  const xcategorys = data.map(d => d.category);

  const xscale = d3.scaleBand()
    .domain(xcategorys)
    .range([padding, w - padding])
    .paddingInner(0.5);

  const yscale = d3.scaleSqrt()
    .domain([0, 350])
    .range([h - padding, padding]);

  const accent = d3.scaleOrdinal(d3.schemeBlues[6]);
  const xaxis = d3.axisBottom(xscale);
  const yaxis = d3.axisLeft(yscale);

  d3.range(numGroups).forEach((gnum) => {
    svg.selectAll('g.group' + gnum)
      .data(datasets[gnum])
      .enter()
      .append('g')
      .attr('fill', accent)
      .attr('class', 'group' + gnum)
      .selectAll('rect')
      .data(d => d)
      .enter()
      .append('rect')
      .attr('x', (d, i) => xscale(xcategorys[i]) + (xscale.bandwidth() / numGroups) * gnum)
      .attr('y', d => yscale(d[1]))
      .attr('width', xscale.bandwidth() / numGroups)
      .attr('height', d => yscale(d[0]) - yscale(d[1]));
  });

  svg.append('g')
    .attr('transform', 'translate(0,' + (h - padding) + ")")
    .call(xaxis);

  svg.append('g')
    .attr('transform', 'translate(' + padding + ",0)")
    .call(yaxis);
}

setupChart('#exampleSimple', dataSimple)
setupChart('#exampleComputed', dataComputed)
setupChart('#exampleRef', dataRef)

const aggregate = [
  {
    category: 'Full render, list',
    simple: dataSimple[0].fullRender,
    computed: dataComputed[0].fullRender,
    ref: dataRef[0].fullRender
  },
  {
    category: 'Full render, list with item components',
    simple: dataSimple[1].fullRender,
    computed: dataComputed[1].fullRender,
    ref: dataRef[1].fullRender
  },
  {
    category: 'Full render, virtual list',
    simple: dataSimple[2].fullRender,
    computed: dataComputed[2].fullRender,
    ref: dataRef[2].fullRender
  },
  {
    category: 'Full render, virtual list with item components',
    simple: dataSimple[3].fullRender,
    computed: dataComputed[3].fullRender,
    ref: dataRef[3].fullRender
  },
  {
    category: 'Insert, list',
    simple: dataSimple[0].insertOperation + dataSimple[0].insertRender,
    computed: dataComputed[0].insertOperation + dataComputed[0].insertRender,
    ref: dataRef[0].insertOperation + dataRef[0].insertRender
  },
  {
    category: 'Insert, list with item components',
    simple: dataSimple[1].insertOperation + dataSimple[1].insertRender,
    computed: dataComputed[1].insertOperation + dataComputed[1].insertRender,
    ref: dataRef[1].insertOperation + dataRef[1].insertRender
  },
  {
    category: 'Insert, virtual list',
    simple: dataSimple[2].insertOperation + dataSimple[2].insertRender,
    computed: dataComputed[2].insertOperation + dataComputed[2].insertRender,
    ref: dataRef[2].insertOperation + dataRef[2].insertRender
  },
  {
    category: 'Insert, virtual list with item components',
    simple: dataSimple[3].insertOperation + dataSimple[3].insertRender,
    computed: dataComputed[3].insertOperation + dataComputed[3].insertRender,
    ref: dataRef[3].insertOperation + dataRef[3].insertRender
  },
  {
    category: 'Update, list',
    simple: dataSimple[0].updateOperation + dataSimple[0].updateRender,
    computed: dataComputed[0].updateOperation + dataComputed[0].updateRender,
    ref: dataRef[0].updateOperation + dataRef[0].updateRender
  },
  {
    category: 'Update, list with item components',
    simple: dataSimple[1].updateOperation + dataSimple[1].updateRender,
    computed: dataComputed[1].updateOperation + dataComputed[1].updateRender,
    ref: dataRef[1].updateOperation + dataRef[1].updateRender
  },
  {
    category: 'Update, virtual list',
    simple: dataSimple[2].updateOperation + dataSimple[2].updateRender,
    computed: dataComputed[2].updateOperation + dataComputed[2].updateRender,
    ref: dataRef[2].updateOperation + dataRef[2].updateRender
  },
  {
    category: 'Update, virtual list with item components',
    simple: dataSimple[3].updateOperation + dataSimple[3].updateRender,
    computed: dataComputed[3].updateOperation + dataComputed[3].updateRender,
    ref: dataRef[3].updateOperation + dataRef[3].updateRender
  },
  {
    category: 'Remove, list',
    simple: dataSimple[0].removeOperation + dataSimple[0].removeRender,
    computed: dataComputed[0].removeOperation + dataComputed[0].removeRender,
    ref: dataRef[0].removeOperation + dataRef[0].removeRender
  },
  {
    category: 'Remove, list with item components',
    simple: dataSimple[1].removeOperation + dataSimple[1].removeRender,
    computed: dataComputed[1].removeOperation + dataComputed[1].removeRender,
    ref: dataRef[1].removeOperation + dataRef[1].removeRender
  },
  {
    category: 'Remove, virtual list',
    simple: dataSimple[2].removeOperation + dataSimple[2].removeRender,
    computed: dataComputed[2].removeOperation + dataComputed[2].removeRender,
    ref: dataRef[2].removeOperation + dataRef[2].removeRender
  },
  {
    category: 'Remove, virtual list with item components',
    simple: dataSimple[3].removeOperation + dataSimple[3].removeRender,
    computed: dataComputed[3].removeOperation + dataComputed[3].removeRender,
    ref: dataRef[3].removeOperation + dataRef[3].removeRender
  }
]

const setupAggregateChart = (container, data) => {
  const w = 700;
  const h = 500;
  const padding = 200;

  const svg = d3.select(container).append('svg').attr('width', w).attr('height', h);

  const datasets = [
    d3.stack().keys(['simple'])(data),
    d3.stack().keys(['computed'])(data),
    d3.stack().keys(['ref'])(data)
  ];

  const numGroups = datasets.length;

  const yCategories = data.map(d => d.category);

  const yscale = d3.scaleBand()
    .domain(yCategories)
    .range([h - 40, 40])
    .paddingInner(0.5);

  const xscale = d3.scaleSqrt()
    .domain([0, 350])
    .range([padding, w - padding]);

  const accent = d3.scaleOrdinal(d3.schemeGreens[4].slice(1, 3));
  const xaxis = d3.axisBottom(xscale);
  const yaxis = d3.axisLeft(yscale);


  d3.range(numGroups).forEach((gnum) => {
    svg.selectAll('g.group' + gnum)
      .data(datasets[gnum])
      .enter()
      .append('g')
      .attr('fill', accent)
      .attr('class', 'group' + gnum)
      .selectAll('rect')
      .data(d => d)
      .enter()
      .append('rect')
      .attr('x', d => xscale(d[0]))
      .attr('y', (d, i) => yscale(yCategories[i]) + (yscale.bandwidth() / numGroups) * gnum)
      .attr('height', yscale.bandwidth() / numGroups)
      .attr('width', d => xscale(d[1]) - xscale(d[0]));
  });

  svg.append('g')
    .attr('transform', 'translate(0,' + (h - 40) + ")")
    .call(xaxis);

  svg.append('g')
    .attr('transform', 'translate(' + padding + ",0)")
    .call(yaxis);
}

setupAggregateChart('#aggregate', aggregate)