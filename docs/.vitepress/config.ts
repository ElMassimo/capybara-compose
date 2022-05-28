import { defineConfig, type UserConfig } from 'vitepress'

const head: UserConfig['head'] = [['link', { rel: 'icon', href: '/favicon.png' }]]

if (process.env.NODE_ENV === 'production')
  head.push(['script', { src: 'https://unpkg.com/thesemetrics@latest', async: '' }])

export default defineConfig({
  lang: 'en-US',
  title: 'Capybara Test Helpers',
  description: 'The perfect companion for your integration tests.',
  head,
  themeConfig: {
    algolia: {
      appId: 'GERZE019PN',
      apiKey: 'cdb4a3df8ecf73fadf6bde873fc1b0d2',
      indexName: 'capybara_test_helpers',
    },

    editLink: {
      repo: 'ElMassimo/capybara_test_helpers',
      branch: 'main',
      dir: 'docs',
      text: 'Edit this page on GitHub'
    },

    socialLinks: [
      { icon: 'github', link: 'https://github.com/ElMassimo/capybara_test_helpers' }
    ],

    footer: {
      message: 'Released under the MIT License.',
      copyright: 'Copyright © 2020-present Máximo Mussini'
    },

    nav: [
      {
        text: 'Guide',
        link: '/guide/',
        activeMatch: '/guide/',
      },
      {
        text: 'API Reference',
        link: '/api/',
        activeMatch: '/api/',
      },
      {
        text: 'Changelog',
        link:
          'https://github.com/ElMassimo/capybara_test_helpers/blob/master/CHANGELOG.md',
      },
    ],

    sidebar: {
      '/': [
        {
          text: 'Guide',
          collapsible: false,
          items: [
            { text: 'Introduction', link: '/guide/introduction.html' },
            { text: 'Installation', link: '/guide/installation.html' },
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
              text: 'Assertions',
              link: '/guide/essentials/assertions.html',
            },
            {
              text: 'Querying',
              link: '/guide/essentials/querying.html',
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
              text: 'Understanding Context',
              link: '/guide/essentials/current-context.html',
            },
          ],
        },
        {
          text: 'Advanced',
          collapsible: false,
          items: [
            {
              text: 'Composition and Injection',
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
              text: 'Synchronization and Waiting',
              link: '/guide/advanced/synchronization.html',
            },
            {
              text: 'Using with Cucumber',
              link: '/guide/cucumber/index.html',
            },
            {
              text: 'API Reference',
              link: '/api/',
            },
          ],
        },
      ]
    },
  },
})
