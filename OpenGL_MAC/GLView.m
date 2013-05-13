//
//  GLView.m
//  OpenGL_MAC
//
//  Created by Xiaoxuan Tang on 13-5-5.
//  Copyright (c) 2013年 txx. All rights reserved.
//

#import "GLView.h"
#import <GLUT/GLUT.h>

@implementation GLView

static int tea_rotation_Y=0;    //定义茶壶自转角度
static int tea_rotation_X=0;    //定义茶壶自转角度
static int tea_translate=0;   //定义茶壶移动单位长度

static int tea_scale_X=1; //定义茶壶缩放比例
static int tea_scale_Y=1; //定义茶壶缩放比例
static int tea_scale_Z=1; //定义茶壶缩放比例

static bool hideWired;
static float zoom;

static void SetupRC(void)
{
    glShadeModel(GL_SMOOTH);
    glFrontFace(GL_CW);
    glClearColor(1.0,1.0,1.0,1.0);
}

static void drawAnObject ()
{
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glEnable(GL_DEPTH_TEST);
    glPushMatrix();
    //画茶壶
    //材质
    GLfloat tea_ambient[] = { 0.0f, 0.2f, 1.0f, 1.0f };
    //指定多边形的正面的环境反射和漫反射值
    glMaterialfv(GL_FRONT, GL_AMBIENT, tea_ambient);
    //镜面，光斑[1，128]
    glMaterialf(GL_FRONT, GL_SHININESS, 20.0);
    
    //双光源
    GLfloat light0_diffuse[]= { 0.0f, 0.0f, 1.0f, 1.0f};
    GLfloat light0_position[] = { 1.0f, 1.0f, 1.0f, 0.0f };
    GLfloat light1_ambient[]= { 0.2f, 0.2f, 0.2f, 1.0f };
    GLfloat light1_diffuse[]= { 1.0f, 1.0f, 1.0f, 1.0f };
    GLfloat light1_specular[] = { 1.0f, 0.6f, 0.6f, 1.0f };
    GLfloat light1_position[] = { -3, -3, 0, 1.0f };
    GLfloat spot_direction[]={ 1.0f, 1.0f, -1.0f};
    
    //light0为漫反射的蓝色点光源
    glLightfv(GL_LIGHT0, GL_DIFFUSE, light0_diffuse);
    glLightfv(GL_LIGHT0, GL_POSITION,light0_position);
    
    //light1为红色聚光光源
    glLightfv(GL_LIGHT1, GL_AMBIENT, light1_ambient);
    glLightfv(GL_LIGHT1, GL_DIFFUSE, light1_diffuse);
    glLightfv(GL_LIGHT1, GL_SPECULAR,light1_specular);
    glLightfv(GL_LIGHT1, GL_POSITION,light1_position);
    glLightf (GL_LIGHT1, GL_SPOT_CUTOFF, 30.0);
    glLightfv(GL_LIGHT1, GL_SPOT_DIRECTION,spot_direction);
    
    //颜色
    glColor3f(0.2f,0.7f,0.1f);
    
    //旋转
    //函数中第一个参数是表示目标沿从原点到指定点(x,y,z)的方向矢量逆时针旋转的角度，后三个参数则是指定旋转方向矢量的坐标。当角度参数是0.0时，表示对物体没有影响。

    glRotatef((GLfloat)tea_rotation_Y, 1.0, 0, 0);   //自转轴的偏转角度
    glRotatef((GLfloat)tea_rotation_X, 0, 1.0, 0);   //自转轴的偏转角度
    
    //平移
    glTranslatef((GLfloat)tea_translate, 0.0, 0.0);
    
    //缩放
    glScalef((GLfloat)tea_scale_X, tea_scale_Y, tea_scale_Z);
    
    glutSolidTeapot(1.0);
    
    if (!hideWired)
    {
        glColor3f(.8,.8,.8);
        glutWireTeapot(1);
    }
    
    glPopMatrix();
    glutSwapBuffers();     // 刷新命令缓冲区
}

- (void) drawRect:(NSRect)dirtyRect
{
    glClearColor(0, 0, 0, 0);
    glClear(GL_COLOR_BUFFER_BIT);
    drawAnObject();
    glFlush();
    
    SetupRC();
    glLoadIdentity();
    gluLookAt (0.0, 0.0, zoom, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0);
}

- (void)reshape
{
    CGSize size = self.frame.size;
    glViewport(0, 0, size.width, size.height);
    
    glMatrixMode (GL_PROJECTION);
    glLoadIdentity ();
    //创建透视投影矩阵,4个参数分别表示：y方向上可见区域的夹角；纵横比为x（宽度）/y（高度）；
    //从观察者到近修剪平面的距离；从观察者到远修剪平面的距离
    gluPerspective(60.0, (GLfloat) size.width/(GLfloat) size.height, 1.0, 20.0);
    // 重置坐标系统，使投影变换复位
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    //定义视景转换,前3个参数表示视点的空间位置；中间3个参数表示参考点的空间位置；最后3
    //个参数表示向上向量的方向
    gluLookAt (0.0, 0.0, zoom, 0.0, 0.0, 0.0, 0.0, 1, 0.0);
}

- (void) mouseDragged:(NSEvent *)theEvent
{
    if (theEvent.deltaY > 0)
    {
        tea_rotation_Y = (tea_rotation_Y - 5) % 360;
    }
    if (theEvent.deltaY < 0)
    {
        tea_rotation_Y = (tea_rotation_Y + 5) % 360;
    }
    
    if (theEvent.deltaX > 0)
    {
        tea_rotation_X = (tea_rotation_X - 5) % 360;
    }
    if (theEvent.deltaX < 0)
    {
        tea_rotation_X = (tea_rotation_X + 5) % 360;
    }
    [self update];
}

//- (void) mouseDown:(NSEvent *)theEvent
//{
//    if (glIsEnabled(GL_LIGHT0))
//    {
//        glDisable(GL_LIGHTING);
//        glDisable(GL_LIGHT0);
//        [self update];
//    }
//    else
//    {
//        glEnable(GL_LIGHTING);
//        glEnable(GL_LIGHT0);
//        [self update];
//    }
//}

- (void)scrollWheel:(NSEvent *)theEvent
{
    if (theEvent.scrollingDeltaY > 0)
    {
        zoom += .1;
        if (zoom > 10) zoom = 10;
        [self update];
    }
    else
    {
        zoom -= .1;
        if (zoom < 3) zoom = 3;
        [self update];
    }
}

- (void) update
{
    [self setNeedsDisplay:YES];
    [super update];
}

- (void)hideWired
{
    hideWired = !hideWired;
    [self update];
}

- (void) hideLight
{
    if (glIsEnabled(GL_LIGHT0))
    {
        glDisable(GL_LIGHTING);
        glDisable(GL_LIGHT0);
        glDisable(GL_LIGHT1);
        [self update];
    }
    else
    {
        glEnable(GL_LIGHTING);
        glEnable(GL_LIGHT0);
        glEnable(GL_LIGHT1);
        [self update];
    }
}

- (void) awakeFromNib
{
    zoom = 5;
    hideWired = false;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hideWired)
                                                 name:@"hideWired"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hideLight)
                                                 name:@"hideLight"
                                               object:nil];
    [super awakeFromNib];
}

void keyboard (unsigned char key, int x, int y)    //定义键盘按键操作
{
    switch (key) {
        case 'r':
            //按键盘r则茶壶顺时针自转，每次旋转角度为10度
            
            break;
        case 'R':
            //按键盘R则茶壶逆时针自转，每次旋转角度为10度
            tea_rotation_Y = (tea_rotation_Y - 10) % 360;
            glutPostRedisplay();
            break;
        case 't':
            //按键盘t则茶壶延X轴正方向移动10单位
            tea_translate = tea_translate + 1;
            glutPostRedisplay();
            break;
        case 'T':
            //按键盘t则茶壶延X轴负方向移动10单位
            tea_translate = tea_translate - 1;
            glutPostRedisplay();
            break;
        case 's':
            //按键盘t则茶壶X轴增大
            tea_scale_X = tea_scale_X + 1;
            glutPostRedisplay(); 
            break; 
        case 'S':   
            //延X轴缩小
            tea_scale_X = tea_scale_X - 1;
            glutPostRedisplay(); 
            break; 
        default: 
            break; 
    } 
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

@end
