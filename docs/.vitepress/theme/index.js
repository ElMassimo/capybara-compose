import DefaultTheme from 'massimopress/dist/client/theme-default'
import Layout from './Layout.vue'
import SampleComponent from '../components/SampleComponent.vue'

import '../styles/styles.css'

export default {
  ...DefaultTheme,
  Layout,
  enhanceApp ({ app, router, siteData }) {
    app.component('SampleComponent', SampleComponent)
  },
}
