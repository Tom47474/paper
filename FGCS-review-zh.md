# ChainOptNet 投稿 FGCS 前审稿报告

审阅日期：2026-10-27。审阅对象：`paper1-cas-dc.tex` 与对应 16 页 PDF。本文未修改论文原稿。

本报告模拟编辑初筛和同行评审，属于审阅判断，不代表 FGCS 编辑部决定。页码、公式编号、图表编号均依据当前 PDF。源文件行号依据当前 LaTeX 文件。

审阅边界：已通读 LaTeX 正文，并核对 PDF 中的方法与实验页面；未获得训练代码、原始实验输出和运行记录，因而不能验证结果真实性、实际实现和统计显著性。下文将“已确认的不一致”与“需要作者澄清或补证据”区分处理。

## 1. 编辑视角的总体结论

**选题与 FGCS 有匹配基础，但当前稿不宜直接投稿；建议先完成实质性修改。** 如果我作为审稿人评阅当前版本，会提出 major revision 级别的问题；如果关键方法定义和实验验证无法补齐，也存在被拒稿的风险。这里不能据此预测实际录用概率。

研究许可链系统在变化负载下的吞吐量与延迟优化，是合理的计算系统研究问题。FGCS 已发表与区块链动态区块大小优化、强化学习性能调优直接相关的论文，说明方向本身可以适配。真正的门槛在于：能否提出区别于已有工作的系统性贡献，并以可信、可复现的系统实验建立证据链。

当前优点是：研究目标明确涉及延迟和吞吐量；模块化结构便于消融；采用可公开获取的数据来源；提供了预测、优化、消融和超参数分析，而不是只给单个模型的准确率。

主要不足不是“英文不够漂亮”，而是以下五项：

1. 研究空白对最接近工作 LearningChain 的概括不准确，容易高估三模块集成的创新性。
2. CFAD 的张量维度与多步预测映射没有闭合；DW-DQN 的奖励、历史依赖与状态定义不完全一致。
3. 没有明确优化环境究竟是真实 Fabric、静态数据查表，还是由性能预测器构造的代理环境。
4. 表格最优值标注、百分比与摘要结论之间存在可核实的不一致。
5. 动态性、实时性、数据稀缺鲁棒性、网络异构性和可扩展性等主张，超过当前报告实验所能支持的范围。

### 1.1 期刊要求核验的边界

核查了官方期刊入口、Aims and Scope 与 Guide for Authors 链接，但本次官方指南正文返回访问限制，未能完整读取。因此，本报告不把第三方模板网站、历史征稿启事或某一专刊的要求当作当前普通稿件的硬性规定。

当前摘要约 219 个英文词（按空格计数），PDF 为 16 页；这两个事实本身不能证明已经满足当前投稿格式。当前使用 `cas-dc`，而不是 `elsarticle`，也不能仅凭模板名称直接判定违规。投稿前应通过实际投稿入口重新核实模板、篇幅、匿名方式、Highlights 和声明要求。

官方入口：

- https://www.sciencedirect.com/journal/future-generation-computer-systems/about/aims-and-scope
- https://www.sciencedirect.com/journal/future-generation-computer-systems/publish/guide-for-authors

## 2. 问题凝练、Abstract 和 Introduction

### 2.1 问题应从“泛区块链性能优化”收缩到明确的控制问题

当前标题和 Introduction 覆盖公链、联盟链、网络异构性、节点动态参与等，但实验主体是基于 Hyperledger Fabric 的性能数据，控制动作仅为区块大小的三种离散调整。这会使编辑产生“问题很大，实际验证很窄”的印象。

建议将核心问题表述为：

> How can a permissioned blockchain adapt its block size to changing transaction arrivals while balancing transaction latency and throughput under prediction errors?

这句话仍需由实验支撑，尤其是 prediction errors；如果不补相应实验，就应删去这一限定。明确以下要素比增加宏观背景更重要：

- 系统：Hyperledger Fabric，还是更广泛的许可链？
- 被控变量：每块最大交易数、字节上限，还是其他 batch 参数？当前 block size 的单位不够明确。
- 扰动：交易到达率、节点数、网络时延，哪些实际变化？
- 时间尺度：到达率聚合周期、预测跨度、控制周期、区块生成周期分别是什么？
- 目标：平均延迟最小化、吞吐量最大化，还是在 SLA 下提高吞吐量？
- 约束：区块大小范围、动作边界、配置生效延迟、调整开销。

标题可考虑：

> ChainOptNet: Forecast-guided adaptive block-size control for permissioned blockchains

若最终实验严格限定 Fabric，可进一步写明 Hyperledger Fabric。“intelligent”“multi-level”目前信息量偏低；文中也未清楚定义 hierarchical learning 或 multi-level learning 的层级。

### 2.2 Abstract：结构完整，但贡献主线与证据口径应改

当前摘要已经包含背景、方法、结果和意义；主要问题如下：

1. 首句通用背景占用篇幅，未直接引出 block-size control 的具体困难。
2. 三段式介绍 CFAD、集成预测和 DW-DQN，读起来更像模块清单，未说明它们如何组成一次预测驱动的控制决策。
3. 未说清楚评估平台与评估方式。基于公开 Fabric 数据的离线实验与在真实 Fabric 集群上在线部署，是不同层级的证据。
4. “21.4%”和“18.7%”在当前正文中没有可直接追溯的汇总表、明确基线名称和计算口径，暂不宜放在摘要中作为核心结果。
5. “best-performing baseline among the evaluated categories”不够明确。预测模型、回归模型、优化控制器对应不同任务，不能笼统合并成一个系统优化基线集合。
6. “scalability”“diverse blockchain environments”“practical deployment”缺少相应实验支撑，应缩小结论范围。

建议按“具体问题—已有方法缺口—控制闭环—评估设置—可追溯结果—适用边界”重写。

下面是偏保守、避免使用尚未核实百分比的英文改写示例。它是修稿参考，不能替代对真实实现的确认：

> Selecting an appropriate block size is challenging in permissioned blockchains because transaction arrivals vary over time and changes in block size affect both latency and throughput. This paper presents ChainOptNet, a prediction-guided framework for adaptive block-size control. The framework combines a convolutional model for transaction-arrival forecasting, an ensemble of regressors for latency and throughput prediction, and a deep Q-network controller with reward weights computed from recent performance trends. The forecasting module provides workload estimates, while the performance models support configuration evaluation. The controller selects discrete block-size adjustments to balance the two performance objectives. We evaluate the forecasting component using parking-arrival records and assess performance prediction and optimization using a public Hyperledger Fabric performance dataset. The reported results indicate improvements in several prediction metrics and in the evaluated block-size optimization settings, although the proposed predictors do not outperform every baseline on every metric. Ablation results suggest that all three components contribute to the reported optimization performance. These findings support further investigation of prediction-guided block-size control for permissioned blockchains; validation on live deployments and under changing network conditions remains necessary.

最终投稿版应在核实后，用一到两组明确的系统收益替换笼统结果句，并减少限制性解释的篇幅。只有真实部署完成后，才能相应改写 deployment 的结论。

### 2.3 Introduction：需要围绕最近邻方法重构

目前 Introduction 的问题：

- 第一段列举大量应用，引用密集，研究问题出现较晚。
- 从 Bitcoin/Ethereum 的 TPS 跳到 Fabric 调参，系统场景没有自然收束；两个平台的数值还缺少版本、工作负载和测量口径。不能用早期设计文献直接支撑持续变化的当代实测平均性能。
- “This causes to ...”有明确语法错误。
- 将不同路线概括为普遍依赖手工阈值、固定策略，过于宽泛；应逐个指出最相关方法的具体限制。
- 强调已有工作把预测与优化分离，但 LearningChain 本身已经具有相关三阶段流程，论证容易被熟悉该领域的审稿人反驳。
- 将节点变化、异构硬件和跨地域网络写成核心挑战，却没有相应测量或实验，会扩大作者必须证明的范围。
- Introduction 与独立 Research motivation 章节重复；后者主要重复观点，没有提供 motivating experiment。

建议采用六段：

1. 在许可链中解释 batching 对等待时间、处理开销和吞吐量的影响。
2. 用一个具体例子或预实验说明固定配置在负载变化下的代价。
3. 介绍 LearningChain 和相关 RL 调参工作，准确说明已有能力。
4. 指出本文真正要解决的剩余问题，例如预测误差与控制效果之间的关系、随运行状态变化的目标权衡。
5. 概述方法，并解释三个模块各自解决上述哪个困难。
6. 给出两到三项可验证贡献及简短结果。

独立 Motivation 章节可以保留，但应增加“不同负载下最佳区块大小变化”“预测误差导致决策损失”“固定权重的 Pareto 权衡”等证据。若不补预实验，建议并入 Introduction，以避免重复。

## 3. 研究动机与创新性

### 3.1 三模块集成本身不足以形成主要创新点

LearningChain 已描述到达率预测、区块链性能建模和评分机制调参三模块，并采用集成学习与元学习。因此，当前“区别于已有方法分离处理这些任务”的说法至少必须限定具体比较对象。

可用的创新论证方向是：在已有预测驱动调参框架基础上，本文具体改变了什么，以及为什么这一改变改善了系统决策。不能仅用更换模型名称、增加基学习器或把评分规则替换为 DQN 来完成论证。

### 3.2 CFAD：需要证明相对于 SOFTS 和普通卷积模型的增量

正文明确说明受 SOFTS 的 STAR 模块启发，但实验没有直接比较 SOFTS。这是明显缺口。SOFTS 原文将其核心描述为基于 MLP 的 series-core fusion 与集中式 STAR 交互。本文应准确说明哪些结构继承、哪些替换、哪些删除，以及这种变化对区块链序列为何有效。

必要对比包括：SOFTS 原始实现、参数规模相近的 CNN/TCN、去掉门控的 CFAD、去掉分发或拼接的变体。除误差外报告参数量、推理时间和训练成本。

“global context”“multi-scale”“spatial dependencies”目前没有获得充分结构定义或实验支持。单个 kernel=3 的卷积堆叠不会自动等同于全局聚合；输入只有一个到达率序列时，也需要解释何为 spatial 或 channel interaction。

### 3.3 多模型预测：目前更像设计选择，而非独立算法创新

七个回归器、二阶特征和误差加权融合均属于常见组成。要将其提升为贡献，需要证明一个明确问题，例如在指定的分布漂移下，在线权重比静态权重更好，且成本可接受。

建议比较：最佳单模型、等权平均、固定验证集权重、在线窗口权重，并报告不同训练数据比例、噪声水平和未见配置上的结果。当前没有这些实验，不能直接宣称在 noisy、incomplete 或 small-sample 条件下有效。

### 3.4 DW-DQN：最可能形成主线，但当前定义与验证不足

将 DQN 用于区块链参数调整已经有相关研究。FGCS 的 PBRL-TChain 就讨论通过 DRL 动态调整区块大小等参数；RLChain 也已在本文文献库中，却主要出现在一般背景引用中，没有充分进入方法对比。

因此应重点证明 trend-aware weighting 的必要性、合理性及收益，而不是把“采用 DQN”作为创新本身。

至少需要：固定权重 DQN 的多组权重扫描、与相同预测器配套的贪心/枚举控制器、合适的现有 RL 调参方案，以及动态权重的时间轨迹。所有控制器需共享动作空间、工作负载与训练预算。

### 3.5 建议的贡献表述

在补齐实现和实验后，可将贡献收束为：

1. 为特定许可链场景定义预测驱动的区块大小控制闭环，明确预测、评估与执行的时间关系。
2. 提出并验证一种经过量纲归一化、历史信息显式进入状态的趋势感知奖励策略。
3. 通过动态工作负载、预测误差、系统开销及消融实验，分析该闭环在何种条件下优于固定配置和已有调参方法。

这是一种建议的研究组织方式，不意味着当前原稿已实现这些内容。

## 4. 算法、公式与符号审查

本稿主要给出模型定义和更新规则，并非需要逐式证明的理论论文。无需为标准 MSE、MAE、DQN TD loss 添加冗长推导；真正应补的是张量维度、执行顺序、假设、边界和实际实现。

### 4.1 CFAD：公式 (1)–(9)

**(a) 卷积轴与输出维度缺失，属于必须澄清的问题。**

式 (1) 给出 X∈R^{L×C}，但没有说明框架实现采用 [batch, channel, time] 还是 [batch, time, channel]，以及实际在哪个轴卷积。

如果卷积沿常规时间轴进行，stride=1 且保持长度的 kernel=1 卷积只进行每个时间点的通道映射，并不会单独建模时间步之间的依赖。所谓“整段序列作为一个 patch”也不能由该式直接推出。如果实现采用反转轴或重排，必须显式写出。

式 (9) 用 kernel=1 投影，却直接声明输出 Y∈R^{L'×1}。在沿时间轴且保持长度的常规实现下，1×1 卷积不能独立完成任意 L→L' 的长度映射。需要补充实际存在的 horizon projection、重排、切片或解码步骤；不能凭审稿建议添加一个未实现的结构。

**(b) 层间递推不闭合。**

- 式 (2) 写 S_N=CFADM(S_0)，未清楚表示 N 层组合。
- 式 (8) 输出 S_i^{out}，下一层使用 S_i，但缺少二者对应关系。
- 图 2 包含 Residual/Fuse，公式没有相应残差更新。
- 建议逐层定义 S_i=CFADM_i(S_{i-1})，并按真实实现写清残差项及通道投影。

**(c) 卷积描述与公式不一致。**

正文称“dual-layer 3×3 convolutions”，式 (3) 仅写一次 Conv1D(kernel=3)。一维卷积应写 kernel size 3；如果实际有两层，应在公式中写出两次卷积和激活。

**(d) 全局性和多尺度没有被证明。**

对无 dilation、stride=1 的 q 个 kernel=3 时间卷积，理论感受野为 1+2q。若每个模块两层，则 N 个模块对应 1+4N。是否覆盖整个输入窗口取决于 L、N 等设置，不能仅称 global。若存在其他汇聚机制，应写出并与图对应。

### 4.2 性能预测：公式 (10)–(19)

**(a) 输入维数符号。**

X=[x_1,…,x_n]∈R^d 中 n 与 d 未对应。建议使用小写向量 x∈R^d，并将系统节点数统一记为 n_t，避免混淆。

**(b) 二阶交互形状。**

式 (11) 将外积矩阵与式 (12) 的向量直接拼接，缺少 flatten/vec。可依实现定义 φ(x)=[z;vech(zz^T)]，其中 z 为标准化特征，vech 只保留不重复项；若实际使用全部 d² 项，也可使用 vec，但需说明维数。原文还需解释为何交互项使用未标准化 X，而其他项使用 X_scaled。

**(c) “inverse-error-based softmax”名称不准确。**

式 (15)/(17) 是 exp(-MAE/T) 的归一化，即负误差 softmax/指数误差加权，不是通常意义上的 1/(MAE+ε) 倒数加权。公式可以保留，但应统一名称，避免全文两种机制混用。

**(d) 延迟和吞吐量误差直接相加存在量纲问题。**

式 (14)/(16) 的 L1 范数把秒和 TPS 的误差相加；输入做 z-score 不等于输出误差已归一化。若目标已标准化，需要说明统计量仅由训练集估计。也可分别定义每个指标的标准化误差 e_{m,j}，分别计算权重 W_{m,j}。分指标权重能否使用，要以实际实现为准。

式 (14) 未除以指标数 k，因此是每样本指标绝对误差之和的平均；若称所有样本、所有输出的 MAE，通常需除以 Nk。固定 k 时不影响模型排序，但会改变温度 T 的尺度。

**(e) 在线误差的因果顺序未交代。**

式 (16) 包含当期 Y_t；若先用 Y_t 更新权重，再预测同一个未知 Y_t，会形成信息泄漏。如果 Y_t 已完成测量且用于预测下一期，则可以成立，但应改用清晰时间下标。在线评价最好使用此前实际生成并保存的预测，而不是在标签出现后重新拟合或重新生成不一致的预测。

建议顺序：利用已完成观测到 t-1 的样本更新权重 → 预测 t 或 t+1 → 真实指标完成测量 → 记录误差并供后续更新。

式 (16) 还直接写 f_m(X)，而训练式 (13) 使用 X_extended，应统一特征变换 φ(X)。

**(f) 基学习器训练目标不透明。**

式 (19) 声称通过同一复合损失优化所有基模型，但 LR、BayesianRidge、树模型等默认训练目标并不相同。不能仅给一条统一损失就完成算法定义。需要说明：是否每个指标单独训练模型；是否使用自定义加权多输出目标；α 是用于训练、模型选择，还是集成评价。若只是事后评价准则，应明确如此，不要表述为所有模型实际最小化的训练损失。

### 4.3 DW-DQN：公式 (20)–(27)

**(a) 状态未包含动态奖励所依赖的历史。**

式 (20) 只有当前 λ_t、b_t、n_t、l_t、τ_t，奖励权重却依赖近期历史。因此，相同当前状态可能对应不同权重和奖励，现有状态定义不足以支撑文中关于该 MDP 的描述。

建议将权重、归一化趋势或相关历史摘要纳入状态，必要时包含队列信息、负载预测和配置生效状态。这样可以修补明显的信息缺失，但是否充分满足 Markov 假设仍需根据实际环境论证，不能自动保证。

同时解释 CFAD 的预测值和性能预测器的输出如何进入决策：当前 λ_t 是当前观测还是未来预测？l_t、τ_t 是测量值还是候选配置的预测值？图和公式必须一致。

**(b) 奖励量纲不一致。**

式 (22) 的延迟偏差有时间单位，式 (23) 的吞吐量比值无量纲。改变延迟单位会改变优化偏好。建议先将两项目标无量纲化，再加权。

**(c) 绝对目标偏差可能惩罚更低延迟。**

若 l* 是延迟上界，-|l-l*| 会惩罚低于目标的延迟，这与“降低延迟”不一致。若目标是满足 SLA，可考虑 -max(0,l/l_SLA-1)；若目标是持续降低延迟，可考虑 -l/l_ref。二者对应不同任务，不能机械替换，应先确定研究目标。

**(d) 奖励应反映动作后果。**

当前 r_t 用 l_t、τ_t 定义，却没有说明这些指标是在动作前还是动作后产生。建议显式写 r_t=r(s_t,a_t,s_{t+1};ω_t)，并标明动作前计算权重、动作执行、指标测量、经验存储的顺序。

**(e) 趋势比例同样存在量纲问题。**

式 (25) 直接比较延迟变化与 TPS 变化，对秒/毫秒的选择敏感。应先分别按延迟参考值与吞吐量参考值归一化，再计算趋势与相对重要性。

**(f) 绝对趋势与“优先处理恶化”不是同一机制。**

|trend_l| 将延迟改善与恶化同等处理；|trend_τ| 也无法区分吞吐量升降。若机制意图是响应恶化，可考虑延迟上升和吞吐量下降的正部；若意图是响应变化幅度，则应准确说明，不能写成只优先处理性能退化。

**(g) 平均一阶差分会发生抵消。**

长度 H 的均值差分实质上等于 (x_t-x_{t-H})/H。它描述净变化，不能刻画窗口内部波动；即使期间剧烈振荡，只要首尾相同，趋势也可以为零。应明确选择的是净趋势还是波动强度，并验证它为何适合控制。

**(h) 零趋势时存在不对称默认值。**

两项趋势都为零时，当前 importance 分别为 0 与 1。在标准、无温度调整的二元 softmax 下，权重约为 0.269 与 0.731，而非均衡权重。若这是设计意图需解释；否则应显式设定零趋势时的默认偏好。

**(i) softmax 和裁剪的精确定义缺失。**

输入 importance 均在 [0,1] 且和为 1，标准 softmax 的权重范围只能约在 [0.269,0.731] 内。权重是否具有预期调节幅度，需要计算说明。裁剪后再归一化也不一般保证仍在原区间内：例如 [0.9,0.1] 裁剪至 [0.2,0.7] 得 [0.7,0.2]，归一化后第一项约 0.778，超过上界。需要定义可行范围与约束投影，或者二元情况下直接定义一个有界权重、另一个取补数。

**(j) DQN 训练细节与 replay 的解释不足。**

TD loss 本身是常规形式，但如果奖励随未纳入状态的历史权重变化，旧经验中的奖励对应什么偏好就不清楚。需明确 replay 保存的状态、权重与奖励、是否重算奖励，以及 target update、探索策略、episode 终止和 done mask。不要声称给出该损失就保证最优策略或收敛。

**(k) 动作约束。**

需给出 Δb、b_min、b_max、配置生效延迟、越界处理方式。若 block size 是交易数，给出整数约束。还需说明 Fabric 中修改相应参数需要什么权限、多久生效以及如何计入控制开销。

### 4.4 缺少可执行的总流程

LaTeX 中存在一段被整段注释的训练伪代码，当前 PDF 未展示该算法。建议补一份与实际代码一致的总流程，明确：

1. 离线数据划分、特征标准化和训练。
2. 每个控制周期可用的测量与历史数据。
3. CFAD 预测跨度以及预测结果进入控制的方式。
4. 性能预测器评估哪些候选配置。
5. 权重计算、动作选择和执行顺序。
6. 状态转移与奖励是从真实系统还是代理环境获得。
7. replay 更新、Q 网络训练及目标网络同步。
8. 部署时是否继续探索或学习，以及如何评价部署成本。

## 5. 实验与结果可信度：当前最需要修改的部分

### 5.1 已确认的表格与文字不一致

**表 2 的最优值加粗和文字结论有错误。**

| 指标 | DTR | Ours | 可以得出的结论 |
|---|---:|---:|---|
| Latency MAE | 0.0218 | 0.0223 | DTR 更低，Ours 不是最低 |
| Throughput MAE | 0.0164 | 0.0167 | DTR 更低，Ours 不是最低 |
| Latency RMSE | — | 0.0519 | Wang et al. 为 0.0481，更低 |

因此必须修改两项 MAE 的加粗及“lowest MAE”等说法。可以准确说 Ours 的 MAPE 最低、吞吐量 RMSE 略低，但还需要重复实验判断小差异是否稳定。

**表 1 的 1-minute MAPE 并非最优。** Autoformer 为 0.2220，Ours 为 0.2486。不能笼统说所有方法、所有指标、所有时间尺度均获胜。1-minute MAE 相比 LSTM 的改善仅约 0.99%，RMSE 改善约 0.57%，应避免在没有误差条的情况下称显著优势。

### 5.2 优化率需要统一计算口径

如果表 3/4 的百分比含义是“所展示平均值的相对改善”，则应分别使用：

延迟下降率 = (baseline latency − optimized latency) / baseline latency ×100%。

吞吐量提升率 = (optimized throughput − baseline throughput) / baseline throughput ×100%。

按当前展示值重算：

| 初始区块大小 | 延迟：原表 / 按均值重算 | 吞吐量：原表 / 按均值重算 |
|---|---|---|
| 50 | 49.78% / 30.65% | 22.09% / 21.65% |
| 100 | 50.73% / 50.57% | 20.70% / 20.24% |
| 150 | 47.36% / 53.76% | 10.66% / 11.33% |
| 200 | 50.09% / 53.76% | 11.35% / 11.61% |

逐样本相对改善的平均与两个总体均值的相对改善确实可以不同。因此这里不能直接断言所有原百分比都计算错误；但必须提供计算式、样本集合和每个初始配置对应的优化后均值。若原表表示逐点比率平均，应明确命名，并解释为何只有一列 Ours 均值。不能将上表重算值直接替换进论文，除非核对原始数据后确认采用这一口径。

摘要 21.4%/18.7%、正文 54%/30% 等也应进入同一结果审计，列清楚对比对象、工作负载、均值或峰值、配对方式。正文的 4.92% error variance reduction 缺少方差定义与对应结果，需补证据或删除。

### 5.3 图 10 的文字趋势与图形不符

Comparative analysis 说 TPS 超过 120 后 score-based 方法出现“noticeable increase in latency”，但图 10 中相应优化延迟柱在该区间总体随负载下降，并不支持这一描述。需逐句对照实际曲线重写，不应套用“高负载导致延迟上升”的常见叙述。

图 10/11 同时显示 Baseline (Wang et al.) 与 Baseline (Ours)。如果它们代表同一系统、同一数据和相同初始配置，优化前表现为什么不同？若代表不同初始配置或不同实验条件，就不能直接用优化后的数值归因于算法差异。应明确共享基线与配对实验设计。

图 11 低负载处部分吞吐量柱看起来高于横轴交易到达率。有限窗口和初始 backlog 可能解释这一现象，因此不能仅凭图判错；但应交代测量窗口、队列初值、提交/完成交易定义及积压处理方式。稳态、无积压、同单位的完成吞吐量应与到达率保持物理一致性。

### 5.4 数据集适用性与闭环实验缺少连接说明

实验 1 使用停车数据，但没有充分交代来源、时间范围、样本数、时间序列定义及到达事件如何形成。真实时间特征不自动使其成为区块链交易负载的有效代理。

建议至少增加一个真实区块链交易时间序列，或明确将停车数据限定为特定 IoT/停车交易场景。不能把这一单一数据源的结果概括为跨区块链泛化。

本文将 Fabric 数据称为 HFBDP，而 LearningChain 原文使用 HFBTP。需核对原始名称、版本、链接；若为处理后的子集，应给出处理方式与命名原因。

消融声称在相同 HFBDP workload traces 下比较完整 pipeline，但前面的数据描述只列出了配置与性能字段，没有给出时序 trace 构建方法。应解释停车到达率预测如何与 Fabric 配置数据匹配，是否缩放/重采样、如何生成动态负载序列、是否严格避免未来信息。

### 5.5 优化环境不明确，是实质性评审问题

必须明确选择并如实报告：

- 若是真实 Fabric 在线交互，给出版本、节点角色与部署、硬件、网络、共识设置、压测工具、交易类型及配置更新方式。
- 若是数据查表，给出状态与动作如何映射到数据行、缺失配置如何处理、是否含历史动态过程。
- 若是性能预测器构造的代理环境，给出转移过程、外生工作负载生成、环境模型训练划分，以及策略如何在独立实测数据或真实系统中验证。

尤其避免同一个预测器既提供训练奖励又充当最终性能裁判。这可能测量的是控制器对代理模型的适应，而非真实系统的改善。单纯配置到指标的静态映射也不能自动支撑长期队列控制的 MDP 叙事；如果没有持续状态，枚举或上下文决策方法可能已经足够，需解释 DQN 的必要性。

### 5.6 最小补充实验集合

1. **数据与复现设置：** 明确样本量、时间顺序划分、训练/验证/测试比例、预处理、随机种子、训练预算、网络规模与全部超参数。当前正文中的数据划分说明被注释，不能算已报告。
2. **防止泄漏：** 标准化与特征选择只拟合训练集；时间序列采用时间切分；相同配置重复测量或高度相似样本应避免跨集合泄漏。再补未见配置/负载范围上的测试。
3. **直接基线：** SOFTS、相同预测器下的枚举/贪心控制、固定权重 DQN 多权重设置，以及适当的已有 RL 调参方法。
4. **动态工作负载：** 明确的阶跃、突发、周期或 trace replay，报告时间序列响应、恢复时间、动作次数和 SLA 违反率。仅在不同静态 TPS 点测试，不足以证明对动态变化的适应。
5. **可重复性：** 给出多次独立训练和独立负载运行的均值、离散程度及适当置信区间，区分训练随机性与系统运行噪声。
6. **系统成本：** 预测与决策延迟、CPU/内存、训练时间、采样和配置生效开销。没有成本数据，不能称 high optimization efficiency 或 real-time deployment。
7. **主张对应实验：** 保留 noisy/incomplete/small-sample 则补相应扰动与数据比例实验；保留 heterogeneous/scalable 则补网络/硬件/规模实验。若无法补，缩小主张。

已有消融值得保留，但“w/o CFAD”实际为用 LSTM 替换，应重命名为 CFAD→LSTM；“w/o Ensemble”需注明具体是哪一个单模型；固定权重需报告取值和选择依据。“替换后变差”只能支持本实验设置下的贡献，不能证明某模块在所有条件下必不可少。

超参数敏感性曲线不是训练收敛曲线。γ 增大带来改善也不能单凭结果断定模型“逐渐学会更好的长期策略”。删除这类没有额外证据的机制解释，补训练回报曲线或改为谨慎描述。

## 6. 英文表达：可读，但尚未达到精炼、自然的学术写作水平

多数句子可以理解，问题集中在：少量明确语法错误、术语漂移、重复铺陈、过度修饰和结果解释不严谨。学术写作质量应以准确、清楚和证据边界为准，不宜只以是否像 native speaker 判断。

### 6.1 可直接处理的语法和搭配

| 位置 | 原表达（短片段） | 建议表达 | 原因 |
|---|---|---|---|
| Introduction，第 187 行 | This causes to increased ... | This leads to increased block propagation delays, transaction congestion, and inefficient resource utilization. | cause to 搭配错误 |
| Experimental design，第 604 行 | three sets of experimentss | three sets of experiments | 拼写错误 |
| Datasets，第 608 行 | In Experiment 1 used ... | In Experiment 1, we used an open-source dataset of parking arrivals ... | 缺少主语，介词结构错误 |
| Datasets，第 610 行 | compiled by [citation] | introduced by Wang et al. ... | 应使用作者型引用，不能用编号充当 by 的施事 |
| CFAD output，第 392 行 | multi-step predicting | multi-step forecasting | 更自然的专业搭配 |
| CFADM，第 350 行附近 | dual-layer 3×3 convolutions | two 1D convolutional layers with a kernel size of 3 | 须先确认实际结构 |
| Metrics，第 650 行附近 | RMSE measures the standard deviation of prediction errors | RMSE measures the root mean squared prediction error and assigns greater weight to large errors. | RMSE 一般不等于误差标准差 |
| Hyperparameters，第 1045 行附近 | all subsequent experiments | all other experiments | 章节顺序中实验已在此前出现；更重要的是明确验证集选参 |
| 表 3 标题 | The optimization rate of optimal block size on latency | Average latency and relative latency reduction | 避免不自然且含义不清的搭配 |
| 表 4 标题 | The optimization rate ... on throughput | Average throughput and relative throughput improvement | 同上 |

### 6.2 需要先修正科学含义的句子

以下句子不能只做英文润色：

- “The proposed model achieved the lowest MAE ...”：与表 2 不符。可改为：The proposed model achieved the lowest latency MAPE, whereas DTR achieved a lower MAE and the prior blockchain-oriented predictor achieved a lower RMSE.
- “CFAD consistently outperforms ... across all time scales”：改为逐指标描述，承认 1-minute MAPE 的例外。
- “These results demonstrate ... scalability ... diverse blockchain environments”：在当前证据下，改为限定于 evaluated Fabric configurations and workloads。
- “lower RMSE ... stronger robustness”：较低 RMSE 支持较小平方误差，不能单独证明分布漂移、噪声或故障下的鲁棒性。
- “MAPE is ... particularly suitable ... across different settings”：必须说明零值/近零值处理、是否在原始单位计算，以及表中采用比例还是百分数。
- “an optimal block-size adjustment policy”：没有最优性分析或充分基准时，改为 a block-size adjustment policy 或 a policy that improves the evaluated objectives。

### 6.3 统一命名

正文至少存在三套基模型列表：总框架包含 SVR；性能模型包含 Bagging Regressor；实验部分把 BR/BYR 解释成 Bayesian Ridge/Bayesian Regularization。图 3 也应同步核对。需建立一张最终模型清单，将缩写、完整名称、软件类名和超参数全部统一。不能凭表格缩写猜测作者实际使用的算法。

建议同时统一：

- transaction arrival rate 与 achieved throughput；图轴不要只用模糊的 TPS 同时指代二者。
- measured latency/throughput 与 predicted latency/throughput。
- block size 的单位与初始化含义。
- negative-error softmax weighting 与 dynamic reward weighting，避免两类权重混称。
- CFAD（预测器）与 CFADM（模块）的层数、命名和复数形式。

### 6.4 减少模板化和宣传性措辞

“transformative paradigm”“intelligently integrating”“strong potential”“superiority”“extensive”“robust”“scalable”等词重复出现，但常没有对应的量化依据。建议用明确动作和结果替换：

- “intelligently integrating diverse machine learning models” → “combining seven regressors using weights derived from recent prediction errors”。
- “significantly improves performance” → 写明指标、数据集、基线和差值；若无统计检验，不使用 statistically significant。
- “demonstrates strong generalization” → 写明在哪个未见配置/工作负载测试集上评估。

每段结果尽量采用：观察到的数值 → 与明确基线的差别 → 有限解释 → 适用边界。不要反复用模型名称与“优越性”代替分析。

## 7. PDF、源文件和投稿完整性

1. 当前 PDF 页眉仍有 “Short Title of the Article”，页脚为 “First Author et al.”，应移除模板占位内容或填写正确短标题、短作者信息。
2. CRediT 中使用 Author 1/Author 2，Acknowledgements 为 “This work was supported by the ...”，尚未完成。匿名稿与独立标题页如何处理，应按真实投稿流程执行。
3. Data availability 仅写 on request，但文中核心来源称 open-source。应给出公共数据链接、版本、访问日期和处理脚本；自生成实验数据与代码单独说明。
4. 图 4 仍标为 Meta-Controller，图内未清楚展示正文所述确定性趋势权重模块。需使图与真实算法一致。
5. 图 6 四幅双轴子图及图 9 的标注在正常阅读尺寸下偏小，建议增加字号、减少双轴依赖或拆分图。
6. 编译日志有多处 overfull hbox，包括表 1 与公式/段落附近；检查表格是否超出版心、长公式是否侵入间距。最终以重新编译的 PDF 为准。
7. 不同模块的预测指标不能直接作为优化控制器“整体优于全部基线类别”的证据；摘要、结论和图表标题都要避免任务层级混淆。

## 8. 建议的修订顺序

### P0：先处理，否则不建议投稿

- 核对原始实验记录，统一全部表格、加粗、优化率和摘要百分比。
- 明确真实系统/查表/代理环境及状态转移，不把预测输出等同于实测系统收益。
- 修正 CFAD 的输入输出维度与层间递推；统一公式与图。
- 明确奖励单位、目标意义、动作后反馈与历史状态。
- 围绕 LearningChain、SOFTS、PBRL-TChain、RLChain 重新界定贡献。

### P1：建立足以支持主要结论的证据

- 补数据划分与复现细节、直接基线和多次重复。
- 补真正的动态负载响应和独立系统性能验证。
- 补算法开销；对未实验的泛化、异构性和鲁棒性主张做删减。
- 明确消融的替换模型与公平预算。

### P2：最后完成叙事和语言

- 重写标题、摘要、Introduction 和贡献列表，使其与最终完成的实验一致。
- 用逐指标、逐场景结论替换笼统的全面优越表述。
- 完成全篇英文编辑、术语表、图表字号和投稿声明。

如果只做语言润色而不处理 P0/P1，当前稿最可能遇到的仍是“创新定位不足、方法难以复现、结论缺乏足够验证”的批评。

## 9. 可供作者自查的模拟审稿意见

> The manuscript addresses an important problem in permissioned blockchain performance optimization. However, the current presentation does not establish a sufficiently clear methodological advance over prior prediction-guided tuning frameworks and reinforcement-learning-based controllers. Several technical definitions remain incomplete, including the forecasting output mapping, the environment transition model, and the relationship between history-dependent reward weights and the stated Markov state. The empirical claims also require reconciliation with the reported tables and a clearer distinction between prediction accuracy and measured system performance. A substantial revision should first resolve these issues, then provide reproducible dynamic-workload evaluations, appropriate direct baselines, and an assessment of control overhead.

## 10. 已核对的相关文献与来源

以下来源用于界定最近邻工作和期刊方向；不据此宣称已完成穷尽的新颖性检索。正式修稿仍应补充截至投稿日期的新文献，并核实卷期年份等书目信息。

1. **PBRL-TChain: A performance-enhanced permissioned blockchain for time-critical applications based on reinforcement learning.** Future Generation Computer Systems 154 (2024), 301–313. DOI: https://doi.org/10.1016/j.future.2023.12.031 。官方页面明确涉及 DRL 驱动的区块大小等参数调整：https://www.sciencedirect.com/science/article/pii/S0167739X23004934 。
2. **A sustainable Bitcoin blockchain network through introducing dynamic block size adjustment using predictive analytics.** Future Generation Computer Systems 153 (2024), 12–26. DOI: https://doi.org/10.1016/j.future.2023.11.005 。用于说明预测驱动区块大小调整与该刊方向的关联，不意味着与 Fabric 场景可直接公平比较。
3. **LearningChain: A Highly Scalable and Applicable Learning-Based Blockchain Performance Optimization Framework.** DOI: https://doi.org/10.1109/TNSM.2023.3347789 。作者公开稿：https://www.sei.ynu.edu.cn/9JishuWang-TNSM.pdf 。可检索原文明确说明三模块流程和 HFBTP 数据集；本次网页工具未成功完整解析该大型 PDF，因此不声称已审阅其全部实现细节。
4. **SOFTS: Efficient Multivariate Time Series Forecasting with Series-Core Fusion.** NeurIPS 2024 官方论文页面：https://proceedings.neurips.cc/paper_files/paper/2024/hash/754612bde73a8b65ad8743f1f6d8ddf6-Abstract-Conference.html 。
5. **RLChain: A DRL Approach for Blockchain Performance Optimization Towards IIoT.** 作者公开稿：https://www.sei.ynu.edu.cn/12AN-TNSM.pdf 。本文 references.bib 已含 `an2024rlchain`，应将其纳入直接相关方法讨论。
