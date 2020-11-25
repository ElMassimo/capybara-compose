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

/** @type {UserConfig} */
const config = {
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
            text: 'Actions',
            link: '/guide/essentials/actions.html',
          },
          {
            text: 'Finders',
            link: '/guide/essentials/finders.html',
          },
          {
            text: 'Querying',
            link: '/guide/essentials/querying.html',
          },
          {
            text: 'Assertions',
            link: '/guide/essentials/assertions.html',
          },
          {
            text: 'Locator Aliases',
            link: '/guide/essentials/aliases.html',
          },
          {
            text: 'Using Test Helpers',
            link: '/guide/essentials/injection.html',
          },
          {
            text: 'Current Context',
            link: '/guide/essentials/current-context.html',
          },
        ],
      },
      {
        text: 'Advanced',
        collapsable: false,
        children: [
          {
            text: 'Composing with Helpers',
            link: '/guide/advanced/composition.html',
          },
          {
            text: 'Debugging',
            link: '/guide/advanced/debugging.html',
          },
          {
            text: 'Filtering with Blocks',
            link: '/guide/advanced/filtering.html',
          },
          {
            text: 'Synchronizing Assertions',
            link: '/guide/advanced/assertions.html',
          },
        ],
      },
      { text: 'In Cucumber', link: '/guide/cucumber/index.html' },
    ],
  },
}

module.exports = config
