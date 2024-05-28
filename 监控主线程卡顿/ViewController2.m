//
//  ViewController2.m
//  监听主线程RunLoop卡顿
//
//  Created by LL on 2024/5/23.
//

#import "ViewController2.h"
#import "WXLLagMonitoring.h"


@interface ViewController2 ()

@property (nonatomic, strong) WXLLagMonitoring *monitor;

@end

@implementation ViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Two View";
    self.view.backgroundColor = UIColor.whiteColor;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"模拟卡顿" forState:UIControlStateNormal];
    [button setBackgroundColor:UIColor.orangeColor];
    [button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    button.frame = CGRectMake(10, 100, 100, 40);
    [button addTarget:self action:@selector(buttonEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeSystem];
    [button2 setTitle:@"上一个页面" forState:UIControlStateNormal];
    [button2 setBackgroundColor:UIColor.orangeColor];
    [button2 setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    button2.frame = CGRectMake(CGRectGetMinX(button.frame), CGRectGetMaxY(button.frame) + 20, 100, 40);
    [button2 addTarget:self action:@selector(button2Event) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
    
    UITextView *textView = [[UITextView alloc] init];
    textView.backgroundColor = UIColor.redColor;
    textView.frame = CGRectMake(0, 0, 200, 300);
    textView.center = self.view.center;
    textView.text = @"纪念日或让人心情蹁跹，流连忘返;或让人低头沉吟，久久思索。其中蕴藏的厚重含义使它不仅仅是日历上一个简单的数字。对于我的爷爷来说，那一天曾是老屋建成的日子，也曾是搬出老屋住进新楼房的日子，是一家人的日子跃上新台阶的日子。家里的老屋曾是爷爷的骄傲。听奶奶说，爷爷小的时候家里穷，住的是祖上传下来的草屋，破旧低矮，三代人挤在一起， 等到爷把奶娶进门，盖两间属于自己的小屋就成了谷爷的梦想。为了这个梦想，爷爷吃过不少苦，受了不少累。一次，公社组织社员们卖菜，地里十颗捆的大白菜，别人扛一捆就被压得直喘粗气，爷爷却- -咬牙一次扛两捆。刚下过雨的泥地很滑，爷爷-一跤摔在地里崴了脚，别人要背爷爷去村里的卫生所，爷爷却自己一把掰正了脚，扛起白菜接着走。奶奶说那天爷爷回到家，脚肿得跟个馒头似的，嘴唇都咬出牙印来了，一直到现在阴天下雨时爷爷的脚还疼呢。但就是靠着这股子干劲，爷谷和奶奶终于盖起了三间属于自己的土坯房。房子盖好后，爷爷没事就围着自己的房子这转转那摸摸，怎么也看不够。那一年爸爸三岁，爷爷拉着爸爸的小手，指着新盖的土坯房对他说:“儿子，这是咱们自己的房子，今后一辈子就住这了。”然后，爷爷带着满脸笑容宣布:“6月15日，建成新房的纪念日!后来，爸爸成家后也有了自己的新房子，爸爸说接爷爷奶奶过来一起住 ,可爷爷却把头摇得像个拨浪鼓，说啥也不肯离开自己的老屋。前几年政府进行城中村改造，各家的旧房子要拆掉盖成楼房，听到这个消息，我心里一愣，脑海里闪现出爷爷不肯离开老屋时倔强的神情。拆了老房子不等于剜了爷爷的心头肉吗?没想到，听了我的担心，爷爷呵呵笑了:“孙女呀，爷爷虽然老了，可是不糊涂，这老房子我是舍不得，但政府不是要赶咱走，人家是拆了旧房给咱盖新房，而且是楼房呢!爷爷老了还能住上楼房了， 不亏!爷爷的一番 话让我豁然开朗，我忽然想起一个简单却实在的道理:旧的不去，新的不来。 搬家的那一天，我去爷爷家帮忙搬东西，爷爷喃喃自语:“不想6月15日又成了搬出老屋的纪念日。”爷爷一直把一个瓦罐抱在怀里，我好奇地问爷爷:“里面是什么值钱的宝贝?”爷爷没有回答，抱着瓦罐坐在炕头上流泪了。后来我才知道，那瓦罐里装的是爷爷从炕头上扫起来的土，爷爷说:“住上大高楼，我就把这瓦罐放在床头，天天看着它，我就能感到咱们国家越变越好! 纪念日记载着一个小家几十年的拼搏与欢笑，也记载着新中国从贫弱到富强的蜕变。纪念日，是爷爷经年累月扛起的一砖一瓦，是无数个日子的蓄势待发，是历史最厚重的注脚，是一代代平凡的中国人艰苦奋斗自力更生之后的幸福生活，是祖国母亲历尽沧桑后的自信与强大。 每一个曾经认真活过的平凡日子都是值得铭记的纪念日。";
    textView.editable = NO;
    [self.view addSubview:textView];
}

- (void)buttonEvent {
    NSLog(@"耗时任务开始：%s-----%f", __func__, [NSDate timeIntervalSinceReferenceDate]);
    CFTimeInterval startTime = CACurrentMediaTime();
    
    for (int i = 0; i < 1000000; i++) {
        NSString *str = [NSString stringWithFormat:@"蓄势待发：%d", i];
        [str stringByAppendingFormat:@"%@", [NSString stringWithFormat:@"厚重的：%d", i + 1]];
    }
    
    CFTimeInterval endTime = CACurrentMediaTime();
    NSLog(@"耗时任务结束：%s----%f----耗时：%g s", __func__, [NSDate timeIntervalSinceReferenceDate], endTime - startTime);
}

- (void)button2Event {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"%s----%f", __func__, [NSDate timeIntervalSinceReferenceDate]);
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

@end
