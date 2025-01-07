package test.java;

import org.junit.jupiter.api.Test;

import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;

import dao.DAO;

	class UserDAOTest {
		
		DAO userDAO=new DAO();
		
		@Test
		void selectUser_testcase1() {
			assertNotNull(userDAO.getUserById(1));
		}

		void selectBoard_testcase1() {
			assertNotNull(userDAO.getDrawingsByBoardId(1));
		}

		@Test
		void createBoard_testcase1() {
			assertTrue(userDAO.createBoard("null", 0));
		}


	}

