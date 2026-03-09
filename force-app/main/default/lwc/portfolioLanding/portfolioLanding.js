import { LightningElement } from 'lwc';

export default class PortfolioLanding extends LightningElement {
    highlights = [
        {
            id: 'core',
            label: 'Master Template Foundation',
            value: 'Track A Complete',
            toneClass: 'chip chip--live'
        },
        {
            id: 'mkt',
            label: 'Catalyst Vertical',
            value: 'Track B Complete',
            toneClass: 'chip chip--live'
        },
        {
            id: 'qa',
            label: 'Apex Test Baseline',
            value: '83 / 83 Passing',
            toneClass: 'chip chip--live'
        },
        {
            id: 'ci',
            label: 'CI Hardening',
            value: 'Pinned Post-MKT',
            toneClass: 'chip chip--queued'
        }
    ];

    verticals = [
        {
            id: 'marketing',
            title: 'Catalyst Marketing Technologies',
            stage: 'Live Case Study',
            stageClass: 'badge badge--live',
            blurb: 'Sales Cloud + Service Cloud + Experience Cloud + Agentforce delivered end-to-end.',
            route: '/portfolio/marketing'
        },
        {
            id: 'environmental',
            title: 'Environmental / Clean Tech',
            stage: 'Queued Next',
            stageClass: 'badge badge--queued',
            blurb: 'Field service, asset lifecycle, and sustainability analytics verticalization.',
            route: '/portfolio/environmental'
        },
        {
            id: 'gis',
            title: 'GIS / Geospatial',
            stage: 'Planned',
            stageClass: 'badge badge--planned',
            blurb: 'Location-centric operations and map-driven service workflows.',
            route: '/portfolio/gis'
        }
    ];
}
