import DefaultTheme from 'massimopress/dist/client/theme-default'
import Layout from './Layout.vue'
import SampleComponent from '../components/SampleComponent.vue'

import '../styles/styles.css'

export default {
  ...DefaultTheme,
  Layout,
  enhanceApp ({ app, router, siteData }) {
    app.component('SampleComponent', SampleComponent)
    // test
    // app is the Vue 3 app instance from createApp()
    // router is VitePress' custom router (see `lib/app/router.js`)
    // siteData is a ref of current site-level metadata.
  },
}
