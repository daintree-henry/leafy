<template>
  <div class="user-container">
    <div class="user-card">
      <div class="user-card__header">
        <h3>사용자 정보</h3>
      </div>
      <div class="user-card__content">
        <p><strong>이름:</strong> {{ currentUser.name }}</p>
        <p><strong>이메일:</strong> {{ currentUser.email }}</p>
        <p><strong>성별:</strong> {{ currentUser.gender }}</p>
        <v-btn class="user-edit-button" @click="showPasswordModal" style="width: 100%">정보 수정</v-btn>
      </div>
    </div>
    <v-dialog v-model="passwordModal" max-width="290">
      <v-card>
        <v-card-title class="headline">비밀번호를 입력하세요.</v-card-title>
        <v-card-text>
          <v-text-field v-model="password" label="비밀번호" type="password"></v-text-field>
        </v-card-text>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn color="green darken-1" text @click="passwordModal = false">취소</v-btn>
          <v-btn color="green darken-1" text @click="editUser">확인</v-btn>
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

    fetchUser();

    
    return {
      ...toRefs(state),
      user,
      showPasswordModal,
      editUser,
    };
  }
};
</script>

<style scoped>
.user-container{
  display: flex;
  justify-content: center;
  align-items: center;
  margin: auto;
}

.user-card {
  border: 1px solid #ccc;
  border-radius: 5px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  padding: 16px;
  width: 300px;
}

.user-card__header {
  background-color: #f5f5f5;
  border-radius: 4px 4px 0 0;
  padding: 8px;
}

.user-card__header h3 {
  margin: 0;
}

.user-card__content {
  padding-top: 16px;
}

.user-card__content p {
  margin: 0 0 8px;
}

.user-card__content p:last-child {
  margin-bottom: 0;
}


.user-edit-button {
  margin-top: 2rem;
  font-size: 1rem;
  font-weight: bold;
  color: white;
  background-color: #8FBC8F;
  border: none;
  border-radius: 0.25rem;
  cursor: pointer;
}
</style>
  