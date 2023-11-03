import axios from "axios";

export default axios.create({
  baseURL: "http://localhost:4000/api/v1",
  headers: {
    "Content-type": "application/json",
    "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIyMDIzIiwibmFtZSI6IkljaGlnbyBJbmMuIiwiaWF0IjoxNTE2MjM5MDIyfQ.BuDOzwrFt7vSBx8Bbt660J3CWVr5eMqeSe1598utJaA"
  }
});
