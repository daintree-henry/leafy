<template>
  <div class="login-page">
    <button type="button" class="demo-login" @click="loginAsDemo">실습 계정으로 바로 로그인</button>
    <div class="login-container">
      <div class="login-brand">
        <div class="brand-mark"><v-icon size="30">mdi-leaf</v-icon></div>
        <h1>LEAFY</h1>
        <p class="tagline">나의 식물을 기록하고 돌보는 곳</p>
      </div>
      <form @submit.prevent="submitLogin">
        <div class="form-group">
          <label for="userEmail">이메일</label>
          <input type="text" id="userEmail" v-model="userEmail" placeholder="이메일을 입력하세요." required />
        </div>
        <div class="form-group">
          <label for="userPassword">비밀번호</label>
          <input type="password" id="userPassword" v-model="userPassword" placeholder="비밀번호를 입력하세요." required />
        </div>
        <button type="submit">로그인</button>
      </form>
    </div>
  </div>
</template>

<script>
import api from '@/api/api';
import { mapState, mapActions } from "vuex";

// 강의 실습용 계정 (leafy-postgresql/init/init.sql에 들어 있는 사용자)
const DEMO_EMAIL = 'john123@qmail.com';
const DEMO_PASSWORD = 'password123';

export default {
  name: "UserLogin",
  data() {
    return {
      userEmail: '',
      userPassword: '',
    };
  },
  mounted() {
    if (this.isLoggedIn) {
      this.$router.replace({ name: 'HomePage' });
    }
  },
  computed: {
    isLoggedIn() {
      return !!this.$store.state.user;
    },
    computed: {
      ...mapState(["popup", "user"])
    },
  },
  methods: {
    ...mapActions(["showPopup"]),
    loginAsDemo() {
      this.userEmail = DEMO_EMAIL;
      this.userPassword = DEMO_PASSWORD;
      this.submitLogin();
    },
    async submitLogin() {
      try {
        const response = await api.post('/api/v1/users/login', {
          email: this.userEmail,
          password: this.userPassword,
        });
        this.$store.dispatch('loginUser', response.data);
        this.$store.dispatch("showPopup", {
          title: "로그인 성공",
          message: `${response.data.name}님, 환영합니다.`,
          status: "success",
          showingSecond: 1500
        });
        this.$router.push({ name: 'HomePage' }); 
      } catch (error) {
        this.$store.dispatch("showPopup", {
          title: "로그인 실패",
          message: "로그인에 실패하였습니다. 아이디와 비밀번호를 확인해주세요.",
          status: "error",
          showingSecond: 1500
        });
        console.error(error);
      }
    },
  },
};
</script>

<style scoped>
.login-page {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 24px;
  box-sizing: border-box;
  background: radial-gradient(circle at 20% 10%, #E6F0E8 0%, rgba(230, 240, 232, 0) 45%),
              radial-gradient(circle at 85% 90%, #EEF4E4 0%, rgba(238, 244, 228, 0) 40%),
              var(--leafy-bg);
}
.login-container {
  width: 100%;
  max-width: 380px;
  background-color: var(--leafy-card);
  border: 1px solid var(--leafy-border);
  border-radius: 20px;
  box-shadow: 0 2px 4px rgba(31, 42, 36, 0.05), 0 16px 40px rgba(31, 42, 36, 0.08);
  padding: 36px 32px 32px;
  box-sizing: border-box;
}
.login-brand {
  text-align: center;
  margin-bottom: 28px;
}
.brand-mark {
  width: 56px;
  height: 56px;
  margin: 0 auto 12px;
  border-radius: 16px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: var(--leafy-green);
  background-color: var(--leafy-green-soft);
}
h1 {
  margin: 0;
  font-weight: 900;
  font-size: 2rem;
  letter-spacing: 0.06em;
  color: var(--leafy-green);
}
.tagline {
  margin: 6px 0 0;
  font-size: 0.9rem;
  color: var(--leafy-muted);
}
form {
  display: flex;
  flex-direction: column;
}
.form-group {
  margin-bottom: 1rem;
  text-align: left;
}
label {
  display: block;
  font-size: 0.85rem;
  font-weight: 700;
  margin-bottom: 0.4rem;
}
input[type="text"],
input[type="password"] {
  padding: 0.75rem 0.85rem;
  font-size: 1rem;
  border: 1px solid var(--leafy-border);
  border-radius: 10px;
  width: 100%;
  box-sizing: border-box;
  outline: none;
  transition: border-color 0.15s, box-shadow 0.15s;
}
input[type="text"]:focus,
input[type="password"]:focus {
  border-color: var(--leafy-green);
  box-shadow: 0 0 0 3px rgba(47, 107, 79, 0.15);
}
button[type="submit"] {
  margin-top: 0.5rem;
  background-color: var(--leafy-green);
  border: none;
  color: white;
  padding: 0.8rem;
  font-size: 1.05rem;
  font-weight: 700;
  border-radius: 10px;
  cursor: pointer;
  width: 100%;
  box-sizing: border-box;
  transition: background-color 0.15s;
}
button[type="submit"]:hover {
  background-color: var(--leafy-green-dark);
}
.demo-login {
  position: fixed;
  top: 16px;
  right: 16px;
  background-color: #F28C28;
  border: none;
  color: white;
  padding: 0.5rem 0.9rem;
  font-size: 0.9rem;
  font-weight: 600;
  border-radius: 4px;
  cursor: pointer;
  box-shadow: 0 2px 6px rgba(0, 0, 0, 0.15);
  z-index: 10;
}
.demo-login:hover {
  background-color: #D9731A;
}
</style>
