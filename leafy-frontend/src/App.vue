<template>
  <div id="app">
    <header class="app-header" v-if="isLoggedIn">
      <div class="header-inner">
        <router-link to="/" class="brand">
          <v-icon size="26" class="brand-icon">mdi-leaf</v-icon>
          <span>LEAFY</span>
        </router-link>
        <NavBar></NavBar>
        <div class="welcome-message">
          <p class="welcome-text">안녕하세요, <span class="user-name">{{ user.name }}</span>님!</p>
          <p class="description">오늘도 즐거운 식물 관리하세요.</p>
        </div>
      </div>
    </header>
    <main class="router-view-wrapper">
      <router-view></router-view>
    </main>
    <footer class="footer" v-if="isLoggedIn">
      <p>&copy; {{ currentYear }} Leafy. All rights reserved.</p>
    </footer>
    <BasicPopup :message="popup.message" :status="popup.status" :visible="popup.visible" @close="closePopup" />
  </div>
</template>

<script>
import BasicPopup from "@/components/BasicPopup.vue";
import NavBar from '@/components/NavBar.vue';
import { mapState } from "vuex";

export default {
  name: "App",
  components: {
    NavBar,
    BasicPopup,
  },
  computed: {
    isLoggedIn() {
      return !!this.$store.state.user;
    },
    currentYear() {
      return new Date().getFullYear();
    },
    ...mapState(["popup", "user"])
  },
  data() {
    return {
      showModal: false,
      modalContent: {
        title: '',
        body: '',
        footer: '',
      },
    };
  },
  provide() {
    return {
      openModal: this.openModal,
    };
  },
  methods: {
    closePopup() {
      this.$store.commit("setPopup", {
        ...this.popup,
        visible: false,
      });
    },
    openModal(content) {
      this.modalContent = content;
      this.showModal = true;
    },
  },
};
</script>

<style>
:root {
  --leafy-green: #2F6B4F;
  --leafy-green-dark: #1F4D38;
  --leafy-green-soft: #E6F0E8;
  --leafy-sage: #8FBC8F;
  --leafy-bg: #F5F7F2;
  --leafy-card: #FFFFFF;
  --leafy-text: #1F2A24;
  --leafy-muted: #6B7A70;
  --leafy-border: #E3E8E0;
  --leafy-water: #2B6CB0;
  --leafy-water-soft: #E6F0FA;
  --leafy-alert: #C2410C;
  --leafy-alert-soft: #FDEEE6;
  --leafy-radius: 16px;
  --leafy-shadow: 0 1px 2px rgba(31, 42, 36, 0.06), 0 4px 16px rgba(31, 42, 36, 0.06);
}

html,
body {
  height: 100%;
  margin: 0;
  background-color: var(--leafy-bg);
}

#app {
  font-family: -apple-system, BlinkMacSystemFont, "Apple SD Gothic Neo", "Malgun Gothic", "Noto Sans KR", "Segoe UI", Roboto, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  color: var(--leafy-text);
  background-color: var(--leafy-bg);
  display: flex;
  flex-direction: column;
  min-height: 100vh;
}

/* 상단 바 */
.app-header {
  position: sticky;
  top: 0;
  z-index: 100;
  background-color: rgba(255, 255, 255, 0.92);
  backdrop-filter: blur(8px);
  border-bottom: 1px solid var(--leafy-border);
}

.header-inner {
  max-width: 1120px;
  margin: 0 auto;
  padding: 0 24px;
  height: 68px;
  display: flex;
  align-items: center;
  gap: 32px;
}

.brand {
  display: flex;
  align-items: center;
  gap: 6px;
  font-size: 1.4rem;
  font-weight: 800;
  letter-spacing: 0.04em;
  color: var(--leafy-green);
  text-decoration: none;
}

.brand-icon {
  color: var(--leafy-sage);
}

.welcome-message {
  margin-left: auto;
  text-align: right;
  line-height: 1.35;
}

.welcome-message p {
  margin: 0;
}

.welcome-text {
  font-size: 0.9rem;
  font-weight: 700;
}

.user-name {
  color: var(--leafy-green);
}

.description {
  font-size: 0.8rem;
  color: var(--leafy-muted);
}

/* 본문 */
.router-view-wrapper {
  flex-grow: 1;
  width: 100%;
}

.page {
  max-width: 1120px;
  margin: 0 auto;
  padding: 32px 24px 56px;
  box-sizing: border-box;
}

.section + .section {
  margin-top: 40px;
}

.section-head {
  display: flex;
  align-items: center;
  gap: 10px;
  margin-bottom: 16px;
}

.section-head h3 {
  margin: 0;
  font-size: 1.25rem;
  font-weight: 800;
}

.section-head .count {
  font-size: 0.85rem;
  font-weight: 700;
  color: var(--leafy-green);
  background-color: var(--leafy-green-soft);
  border-radius: 999px;
  padding: 2px 10px;
}

.section-head .actions {
  margin-left: auto;
}

.card-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(240px, 1fr));
  gap: 20px;
}

.leafy-card {
  background-color: var(--leafy-card);
  border: 1px solid var(--leafy-border);
  border-radius: var(--leafy-radius);
  box-shadow: var(--leafy-shadow);
  overflow: hidden;
}

.leafy-card.clickable {
  cursor: pointer;
  transition: transform 0.15s ease, box-shadow 0.15s ease;
}

.leafy-card.clickable:hover {
  transform: translateY(-2px);
  box-shadow: 0 2px 4px rgba(31, 42, 36, 0.08), 0 10px 24px rgba(31, 42, 36, 0.1);
}

.chip {
  display: inline-flex;
  align-items: center;
  gap: 4px;
  font-size: 0.78rem;
  font-weight: 700;
  border-radius: 999px;
  padding: 3px 10px;
  white-space: nowrap;
}

.chip-green {
  color: var(--leafy-green);
  background-color: var(--leafy-green-soft);
}

.chip-water {
  color: var(--leafy-water);
  background-color: var(--leafy-water-soft);
}

.chip-alert {
  color: var(--leafy-alert);
  background-color: var(--leafy-alert-soft);
}

.btn-primary {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  background-color: var(--leafy-green);
  color: #fff;
  border: none;
  border-radius: 10px;
  padding: 10px 16px;
  font-size: 0.95rem;
  font-weight: 700;
  cursor: pointer;
  transition: background-color 0.15s;
}

.btn-primary:hover {
  background-color: var(--leafy-green-dark);
}

.empty {
  color: var(--leafy-muted);
  background-color: var(--leafy-card);
  border: 1px dashed var(--leafy-border);
  border-radius: var(--leafy-radius);
  padding: 32px;
  text-align: center;
}

.footer {
  border-top: 1px solid var(--leafy-border);
  color: var(--leafy-muted);
  font-size: 0.85rem;
  text-align: center;
  padding: 20px;
}

.footer p {
  margin: 0;
}

@media (max-width: 768px) {
  .header-inner {
    height: auto;
    flex-wrap: wrap;
    gap: 4px 12px;
    padding: 10px 16px;
  }

  .welcome-message {
    order: 3;
    width: 100%;
    margin-left: 0;
    text-align: left;
  }

  .welcome-text {
    display: none;
  }

  .page {
    padding: 24px 16px 48px;
  }
}
</style>
