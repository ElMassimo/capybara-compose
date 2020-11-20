/** @typedef {import('vitepress').UserConfig} UserConfig */

/** @type {UserConfig['head']} */
const head = [['link', { rel: 'icon', href: '/favicon.png' }]]

if (process.env.NODE_ENV === 'production') {
  head.push([
    'script',
    {
      src: 'https://unpkg.com/thesemetrics@latest',
      async: '',
    },
  ])
}

const base = process.env.GITHUB_PAGES ? '/capybara_test_helpers/' : '/'

/** @type {UserConfig} */
const config = {
  base,
  lang: 'en-US',
  title: 'Capybara Test Helpers',
  description: 'The perfect companion for your integration tests.',
  head,

  // serviceWorker: true,

  themeConfig: {
    repo: 'ElMassimo/capybara_test_helpers',
    docsRepo: 'ElMassimo/capybara_test_helpers',
    docsDir: 'docs',
    docsBranch: 'master',
    editLinks: true,

    algolia: {
      appId: 'GERZE019PN',
      apiKey: 'cdb4a3df8ecf73fadf6bde873fc1b0d2',
      indexName: 'capybara_test_helpers',
    },

    nav: [
      {
        text: 'Guide',
        link: '/guide/',
      },
      {
        text: 'API Reference',
        link: '/api/',
      },
      {
        text: 'Changelog',
        link:
          'https://github.com/ElMassimo/capybara_test_helpers/blob/master/CHANGELOG.md',
      },
    ],

    sidebar: [
      { text: 'Introduction', link: '/introduction.html' },
      { text: 'Installation', link: '/installation.html' },
      {
        text: 'Basic Usage',
        collapsable: false,
        children: [
          {
            text: 'Getting Started',
            link: '/guide/index.html',
          },
          {
            text: 'Selectors',
            link: '/guide/essentials/selectors.html',
          },
          {
            text: 'Assertions',
            link: '/guide/essentials/assertions.html',
          },
          {
            text: 'Actions',
            link: '/guide/essentials/actions.html',
          },
          {
            text: 'Finders',
            link: '/guide/essentials/finders.html',
          },
          {
            text: 'Matchers',
            link: '/guide/essentials/matchers.html',
          },
        ],
      },
      {
        text: 'Advanced',
        collapsable: false,
        children: [
          {
            text: 'Synchronizing Assertions',
            link: '/guide/advanced/synchronization.html',
          },
          {
            text: 'Design Patterns',
            link: '/guide/advanced/design-patterns.html',
          },
        ],
      },
      { text: 'Migrating from Cucumber', link: '/guide/migrating_from_cucumber/index.html' },
    ],
  },
}

module.exports = config
