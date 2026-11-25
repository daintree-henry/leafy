<template>
  <div class="page">
    <div class="user-container">
      <div class="leafy-card user-card">
        <div class="user-card__header">
          <div class="avatar">{{ currentUser.name ? currentUser.name.charAt(0) : '' }}</div>
          <div>
            <h3>{{ currentUser.name }}</h3>
            <p class="email">{{ currentUser.email }}</p>
          </div>
        </div>
        <dl class="user-card__content">
          <div class="row"><dt>이름</dt><dd>{{ currentUser.name }}</dd></div>
          <div class="row"><dt>이메일</dt><dd>{{ currentUser.email }}</dd></div>
          <div class="row"><dt>성별</dt><dd>{{ genderLabel }}</dd></div>
          <div class="row" v-if="currentUser.birthDate"><dt>생년월일</dt><dd>{{ formatDate(currentUser.birthDate) }}</dd></div>
        </dl>
        <button class="btn-primary user-edit-button" @click="showPasswordModal"><v-icon size="18">mdi-account-edit-outline</v-icon>정보 수정</button>
        <button class="logout-button" @click="logout"><v-icon size="18">mdi-logout</v-icon>로그아웃</button>
      </div>
    </div>
    <v-dialog v-model="passwordModal" max-width="360">
      <v-card rounded="lg" class="pa-2">
        <v-card-title class="dialog-title">비밀번호를 입력하세요.</v-card-title>
        <v-card-text>
          <v-text-field v-model="password" label="비밀번호" type="password" variant="outlined" color="#2F6B4F" @keyup.enter="editUser"></v-text-field>
        </v-card-text>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn variant="text" @click="passwordModal = false">취소</v-btn>
          <v-btn color="#2F6B4F" variant="flat" @click="editUser">확인</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </div>
</template>

<script>
import { reactive, toRefs, computed } from 'vue';
import api from '@/api/api';
import { useRouter } from 'vue-router';
import { useStore } from 'vuex';
import { formatDate } from '@/utils/date';


export default {
  name: "UserCard",
  setup() {
    const router = useRouter();
    const store = useStore();

    const state = reactive({
      currentUser: [],
      passwordModal: false,
      password: '',
    });

    const user = computed(() => store.state.user);

    const genderLabel = computed(() => {
      if (state.currentUser.gender === 'M') return '남성';
      if (state.currentUser.gender === 'F') return '여성';
      return state.currentUser.gender || '';
    });

    const fetchUser = async () => {
      const userId = user.value.userId;
      api.get(`/api/v1/users/${userId}`)
        .then(response => {
          state.currentUser = response.data;
        })
        .catch(error => {
          console.error(error);
        });
    };

    const showPasswordModal = () => {
      state.passwordModal = true;
    };

    const editUser = async () =>{
      try {
        await api.post('/api/v1/users/login', {
          email: user.value.email,
          password: state.password,
        });
        router.push({ name: 'UserEdit' });
      } catch (error) {
        store.dispatch("showPopup", {
          title: "사용자 인증 실패",
          message: "비밀번호가 일치하지 않습니다.",
          status: "error",
          showingSecond: 1500
        });
        console.error(error);
      }
      state.passwordModal = false;
      state.password = '';
    };

    const logout = () => {
      store.dispatch('logoutUser');
      router.push({ name: 'HomePage' });
    };

    fetchUser();


    return {
      ...toRefs(state),
      user,
      genderLabel,
      showPasswordModal,
      editUser,
      logout,
      formatDate,
    };
  }
};
</script>

<style scoped>
.user-container {
  max-width: 440px;
  margin: 0 auto;
}

.user-card {
  padding: 28px;
}

.user-card__header {
  display: flex;
  align-items: center;
  gap: 16px;
  margin-bottom: 20px;
}

.avatar {
  width: 56px;
  height: 56px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 1.4rem;
  font-weight: 800;
  color: var(--leafy-green);
  background-color: var(--leafy-green-soft);
}

.user-card__header h3 {
  margin: 0;
  font-size: 1.2rem;
  font-weight: 800;
}

.email {
  margin: 2px 0 0;
  color: var(--leafy-muted);
  font-size: 0.9rem;
}

.user-card__content {
  margin: 0 0 24px;
  border-top: 1px solid var(--leafy-border);
}

.row {
  display: flex;
  justify-content: space-between;
  padding: 12px 0;
  border-bottom: 1px solid var(--leafy-border);
  font-size: 0.95rem;
}

.row dt {
  color: var(--leafy-muted);
}

.row dd {
  margin: 0;
  font-weight: 600;
}

.user-edit-button {
  width: 100%;
  justify-content: center;
}

.logout-button {
  width: 100%;
  margin-top: 10px;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 6px;
  background-color: transparent;
  color: var(--leafy-muted);
  border: 1px solid var(--leafy-border);
  border-radius: 10px;
  padding: 10px 16px;
  font-size: 0.95rem;
  font-weight: 700;
  cursor: pointer;
  transition: background-color 0.15s, color 0.15s;
}

.logout-button:hover {
  color: var(--leafy-text);
  background-color: var(--leafy-bg);
}

.dialog-title {
  font-size: 1.05rem;
  font-weight: 800;
}
</style>
