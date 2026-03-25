package com.abajin.innovation.service;

import com.abajin.innovation.common.PageResult;
import com.abajin.innovation.dto.CreateUserDTO;
import com.abajin.innovation.dto.LoginDTO;
import com.abajin.innovation.dto.RegisterDTO;
import com.abajin.innovation.dto.UserQueryDTO;
import com.abajin.innovation.entity.User;
import com.abajin.innovation.mapper.UserMapper;
import com.abajin.innovation.mapper.CollegeMapper;
import com.abajin.innovation.util.JwtUtil;
import com.abajin.innovation.common.Constants;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class UserService {
    @Autowired
    private UserMapper userMapper;

    @Autowired
    private CollegeMapper collegeMapper;

    @Autowired
    private JwtUtil jwtUtil;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Transactional(readOnly = true)
    public String login(LoginDTO loginDTO) {
        User user = userMapper.selectByUsername(loginDTO.getUsername());
        if (user == null) {
            throw new RuntimeException("用户名或密码错误");
        }

        // 验证密码
        if (!passwordEncoder.matches(loginDTO.getPassword(), user.getPassword())) {
            throw new RuntimeException("用户名或密码错误");
        }

        if (user.getStatus() == Constants.USER_STATUS_DISABLED) {
            throw new RuntimeException("账户已被禁用");
        }

        return jwtUtil.generateToken(user.getId(), user.getUsername(), user.getRole());
    }

    @Transactional
    public User register(RegisterDTO registerDTO) {
        // 检查用户名是否已存在
        User existingUser = userMapper.selectByUsername(registerDTO.getUsername());
        if (existingUser != null) {
            throw new RuntimeException("用户名已存在");
        }

        User user = new User();
        user.setUsername(registerDTO.getUsername());
        user.setPassword(passwordEncoder.encode(registerDTO.getPassword()));
        user.setRealName(registerDTO.getRealName());
        user.setEmail(registerDTO.getEmail());
        user.setPhone(registerDTO.getPhone());
        user.setRole(registerDTO.getRole());
        user.setCollegeId(registerDTO.getCollegeId());
        user.setStatus(Constants.USER_STATUS_ENABLED);
        user.setCreateTime(LocalDateTime.now());
        user.setUpdateTime(LocalDateTime.now());

        // 如果提供了学院ID，查询学院名称
        if (registerDTO.getCollegeId() != null) {
            var college = collegeMapper.selectById(registerDTO.getCollegeId());
            if (college != null) {
                user.setCollegeName(college.getName());
            }
        }

        userMapper.insert(user);
        return user;
    }

    @Transactional(readOnly = true)
    public User getUserById(Long id) {
        return userMapper.selectById(id);
    }

    @Transactional(readOnly = true)
    public User getUserByUsername(String username) {
        return userMapper.selectByUsername(username);
    }

    /**
     * 修改当前用户密码
     * @param userId 当前用户ID（从 token 获取）
     * @param oldPassword 原密码
     * @param newPassword 新密码
     */
    @Transactional
    public void changePassword(Long userId, String oldPassword, String newPassword) {
        if (oldPassword == null || oldPassword.isEmpty()) {
            throw new RuntimeException("请输入原密码");
        }
        if (newPassword == null || newPassword.length() < 6) {
            throw new RuntimeException("新密码长度不能少于6位");
        }
        User user = userMapper.selectById(userId);
        if (user == null) {
            throw new RuntimeException("用户不存在");
        }
        if (!passwordEncoder.matches(oldPassword, user.getPassword())) {
            throw new RuntimeException("原密码错误");
        }
        user.setPassword(passwordEncoder.encode(newPassword));
        user.setUpdateTime(LocalDateTime.now());
        userMapper.update(user);
    }

    /**
     * 管理员创建用户
     * @param createUserDTO 创建用户数据
     * @return 创建的用户
     */
    @Transactional
    public User createUser(CreateUserDTO createUserDTO) {
        // 检查用户名是否已存在
        User existingUser = userMapper.selectByUsername(createUserDTO.getUsername());
        if (existingUser != null) {
            throw new RuntimeException("用户名已存在");
        }

        User user = new User();
        user.setUsername(createUserDTO.getUsername());
        user.setPassword(passwordEncoder.encode(createUserDTO.getPassword()));
        user.setRealName(createUserDTO.getRealName());
        user.setEmail(createUserDTO.getEmail());
        user.setPhone(createUserDTO.getPhone());
        user.setRole(createUserDTO.getRole());
        user.setCollegeId(createUserDTO.getCollegeId());
        // 如果未指定状态，默认启用
        user.setStatus(createUserDTO.getStatus() != null ? createUserDTO.getStatus() : Constants.USER_STATUS_ENABLED);
        user.setCreateTime(LocalDateTime.now());
        user.setUpdateTime(LocalDateTime.now());

        // 如果提供了学院ID，查询学院名称
        if (createUserDTO.getCollegeId() != null) {
            var college = collegeMapper.selectById(createUserDTO.getCollegeId());
            if (college != null) {
                user.setCollegeName(college.getName());
            }
        }

        userMapper.insert(user);
        return user;
    }

    /**
     * 分页查询用户列表
     * @param queryDTO 查询条件
     * @return 分页结果
     */
    @Transactional(readOnly = true)
    public PageResult<User> getUserList(UserQueryDTO queryDTO) {
        // 构建查询条件
        List<User> list = userMapper.selectByCondition(
                queryDTO.getUsername(),
                queryDTO.getRealName(),
                queryDTO.getRole(),
                queryDTO.getCollegeId(),
                queryDTO.getStatus()
        );
        
        // 手动分页
        int total = list.size();
        int start = (queryDTO.getPageNum() - 1) * queryDTO.getPageSize();
        int end = Math.min(start + queryDTO.getPageSize(), total);
        
        List<User> pageList = start < total ? list.subList(start, end) : List.of();
        
        return new PageResult<>(queryDTO.getPageNum(), queryDTO.getPageSize(), (long) total, pageList);
    }

    /**
     * 更新用户状态
     * @param userId 用户ID
     * @param status 状态：0-禁用，1-启用
     */
    @Transactional
    public void updateUserStatus(Long userId, Integer status) {
        User user = userMapper.selectById(userId);
        if (user == null) {
            throw new RuntimeException("用户不存在");
        }
        user.setStatus(status);
        user.setUpdateTime(LocalDateTime.now());
        userMapper.update(user);
    }

    /**
     * 重置用户密码
     * @param userId 用户ID
     * @param newPassword 新密码
     */
    @Transactional
    public void resetPassword(Long userId, String newPassword) {
        if (newPassword == null || newPassword.length() < 6) {
            throw new RuntimeException("密码长度不能少于6位");
        }
        User user = userMapper.selectById(userId);
        if (user == null) {
            throw new RuntimeException("用户不存在");
        }
        user.setPassword(passwordEncoder.encode(newPassword));
        user.setUpdateTime(LocalDateTime.now());
        userMapper.update(user);
    }

    /**
     * 更新用户信息
     * @param userId 用户ID
     * @param userData 用户数据
     */
    @Transactional
    public void updateUser(Long userId, User userData) {
        User user = userMapper.selectById(userId);
        if (user == null) {
            throw new RuntimeException("用户不存在");
        }
        
        // 不允许修改用户名
        if (StringUtils.hasText(userData.getRealName())) {
            user.setRealName(userData.getRealName());
        }
        if (StringUtils.hasText(userData.getEmail())) {
            user.setEmail(userData.getEmail());
        }
        if (StringUtils.hasText(userData.getPhone())) {
            user.setPhone(userData.getPhone());
        }
        if (userData.getCollegeId() != null) {
            user.setCollegeId(userData.getCollegeId());
            var college = collegeMapper.selectById(userData.getCollegeId());
            if (college != null) {
                user.setCollegeName(college.getName());
            }
        }
        if (StringUtils.hasText(userData.getRole())) {
            user.setRole(userData.getRole());
        }
        
        user.setUpdateTime(LocalDateTime.now());
        userMapper.update(user);
    }

    /**
     * 删除用户
     * @param userId 用户ID
     */
    @Transactional
    public void deleteUser(Long userId) {
        User user = userMapper.selectById(userId);
        if (user == null) {
            throw new RuntimeException("用户不存在");
        }
        // TODO: 检查用户是否有关联数据（项目、团队等），如果有则不允许删除
        userMapper.deleteById(userId);
    }
}
